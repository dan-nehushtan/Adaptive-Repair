# src/check_data_root.py
from data_paths import get_data_root, d

def main():
    root = get_data_root()
    print("DATA_ROOT OK:", root)
    print("Model path:", d("YOLOv8_LSM.pt"))

if __name__ == "__main__":
    main()