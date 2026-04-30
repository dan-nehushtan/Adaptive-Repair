# src/inspect_yolo_model.py
"""
Inspect the YOLOv8_LSM.pt model file and extract all useful metadata.

Prints: architecture, class names, layer count, parameter count,
input size, training args, and more.
"""

from __future__ import annotations

import sys
from pathlib import Path

import torch


def inspect_model(model_path: Path) -> None:
    print(f"{'=' * 70}")
    print(f"  YOLOv8 MODEL INSPECTION — {model_path.name}")
    print(f"{'=' * 70}")
    print(f"  File size: {model_path.stat().st_size / 1e6:.2f} MB")
    print()

    # ── 1. Raw checkpoint contents ───────────────────────────────────
    ckpt = torch.load(str(model_path), map_location="cpu", weights_only=False)

    print("─── Top-level checkpoint keys ───")
    for key in sorted(ckpt.keys()):
        val = ckpt[key]
        dtype = type(val).__name__
        if isinstance(val, dict):
            print(f"  {key:25s}  dict ({len(val)} keys)")
        elif isinstance(val, (list, tuple)):
            print(f"  {key:25s}  {dtype} (len {len(val)})")
        elif isinstance(val, torch.Tensor):
            print(f"  {key:25s}  Tensor {tuple(val.shape)}")
        else:
            print(f"  {key:25s}  {dtype}: {val}")
    print()

    # ── 2. Training arguments / hyperparameters ──────────────────────
    train_args = ckpt.get("train_args") or ckpt.get("args") or {}
    if train_args:
        print("─── Training arguments ───")
        # Could be a dict or a namespace — normalise
        if not isinstance(train_args, dict):
            try:
                train_args = vars(train_args)
            except TypeError:
                train_args = {"raw": str(train_args)}
        for k, v in sorted(train_args.items()):
            print(f"  {k:30s}  {v}")
        print()

    # ── 3. Class names ───────────────────────────────────────────────
    # Try multiple locations where YOLO stores class names
    names = (
        ckpt.get("names")
        or (ckpt.get("model").names if hasattr(ckpt.get("model", None), "names") else None)
        or (train_args.get("names") if isinstance(train_args, dict) else None)
    )
    if names:
        print("─── Class names ───")
        if isinstance(names, dict):
            for idx, name in sorted(names.items()):
                print(f"  {idx}: {name}")
        elif isinstance(names, (list, tuple)):
            for idx, name in enumerate(names):
                print(f"  {idx}: {name}")
        else:
            print(f"  {names}")
        print()

    # ── 4. Model architecture via Ultralytics ────────────────────────
    try:
        from ultralytics import YOLO

        model = YOLO(str(model_path))
        info = model.info(verbose=False)

        print("─── Model summary (via Ultralytics) ───")
        print(f"  Task          : {model.task}")
        print(f"  Model type    : {type(model.model).__name__}")

        # Class names from loaded model
        if hasattr(model, "names") and model.names:
            print(f"  Classes       : {len(model.names)}")
            for idx, name in model.names.items():
                print(f"                  {idx}: {name}")

        # Parameter counts
        if hasattr(model.model, "parameters"):
            total_params = sum(p.numel() for p in model.model.parameters())
            trainable = sum(p.numel() for p in model.model.parameters() if p.requires_grad)
            print(f"  Total params  : {total_params:,}")
            print(f"  Trainable     : {trainable:,}")
            print(f"  Frozen        : {total_params - trainable:,}")

        # Count layers
        if hasattr(model.model, "model"):
            n_layers = len(list(model.model.model))
            print(f"  Layers (top)  : {n_layers}")

        # Input shape expectation
        if isinstance(train_args, dict):
            imgsz = train_args.get("imgsz")
            if imgsz:
                print(f"  Training imgsz: {imgsz}")

        print()

        # ── 5. Detailed layer breakdown ──────────────────────────────
        print("─── Layer architecture ───")
        print(f"  {'#':>3}  {'Type':30s}  {'Output shape':20s}  {'Params':>12}")
        print(f"  {'─'*3}  {'─'*30}  {'─'*20}  {'─'*12}")

        if hasattr(model.model, "model"):
            for i, layer in enumerate(model.model.model):
                layer_type = type(layer).__name__
                n = sum(p.numel() for p in layer.parameters())

                # Try to get output channels / shape info
                shape_str = ""
                if hasattr(layer, "cv2") and hasattr(layer.cv2, "conv"):
                    shape_str = f"ch={layer.cv2.conv.out_channels}"
                elif hasattr(layer, "conv") and hasattr(layer.conv, "out_channels"):
                    shape_str = f"ch={layer.conv.out_channels}"
                elif hasattr(layer, "out_channels"):
                    shape_str = f"ch={layer.out_channels}"

                print(f"  {i:3d}  {layer_type:30s}  {shape_str:20s}  {n:>12,}")
        print()

        # ── 6. Training metrics (if stored) ──────────────────────────
        epoch = ckpt.get("epoch")
        best_fitness = ckpt.get("best_fitness")
        if epoch is not None:
            print("─── Training state ───")
            print(f"  Epoch (last)  : {epoch}")
        if best_fitness is not None:
            print(f"  Best fitness  : {best_fitness}")

        # Extract metrics from train_args
        if isinstance(train_args, dict):
            metrics_keys = [k for k in train_args if any(
                m in k.lower() for m in ["map", "precision", "recall", "loss",
                                          "lr", "batch", "epoch", "data",
                                          "optimizer", "augment"]
            )]
            if metrics_keys:
                print()
                print("─── Key training config ───")
                for k in sorted(metrics_keys):
                    print(f"  {k:30s}  {train_args[k]}")

        print()

    except Exception as e:
        print(f"  Could not load via Ultralytics: {e}")
        print()

    # ── 7. EMA / optimizer state info ────────────────────────────────
    if "ema" in ckpt and ckpt["ema"] is not None:
        print("─── EMA (Exponential Moving Average) ───")
        print("  EMA model is stored in checkpoint (used for inference)")
        if hasattr(ckpt["ema"], "parameters"):
            ema_params = sum(p.numel() for p in ckpt["ema"].parameters())
            print(f"  EMA params: {ema_params:,}")
        print()

    if "optimizer" in ckpt and ckpt["optimizer"] is not None:
        opt = ckpt["optimizer"]
        if isinstance(opt, dict):
            print("─── Optimizer state ───")
            if "param_groups" in opt:
                for i, pg in enumerate(opt["param_groups"]):
                    lr = pg.get("lr", "?")
                    wd = pg.get("weight_decay", "?")
                    print(f"  Group {i}: lr={lr}, weight_decay={wd}")
            print()

    print(f"{'=' * 70}")
    print("  Inspection complete.")
    print(f"{'=' * 70}")


if __name__ == "__main__":
    from config import MODEL_PATH

    if len(sys.argv) > 1:
        path = Path(sys.argv[1])
    else:
        path = MODEL_PATH

    if not path.exists():
        print(f"Model file not found: {path}")
        sys.exit(1)

    inspect_model(path)
