# src/data_paths.py
from pathlib import Path

# === EDIT ONLY THIS ===
# Data lives inside the repo under Adaptive Repair Strategies/data/
DATA_ROOT = Path(
    r"C:\Users\dnehu\Documents\University\Year 4\Engineering"
    r"\MECH5080-Team-Project\Machine Learning In Advanced Manufacturing"
    r"\Adaptive Repair Strategies\data"
)

def get_data_root() -> Path:
    """
    Returns the root dataset folder and checks it exists.
    This is the one function you import everywhere.
    """
    if not DATA_ROOT.exists():
        raise FileNotFoundError(
            f"DATA_ROOT not found:\n{DATA_ROOT}\n"
            "Edit DATA_ROOT in src/data_paths.py"
        )
    return DATA_ROOT

def d(*parts: str) -> Path:
    """
    Convenience joiner:
      d('YOLOv8_LSM.pt') -> <DATA_ROOT>/YOLOv8_LSM.pt
      d('10_14_30','Disk_Defects.txt') -> <DATA_ROOT>/10_14_30/Disk_Defects.txt
    """
    return get_data_root().joinpath(*parts)