import argparse

def main():
    parser = argparse.ArgumentParser(description="Run HR synthetic data pipeline")
    parser.add_argument("--seed", type=int, default=20261022)
    parser.add_argument("--scale", choices=["starter", "full"], default="starter")
    args = parser.parse_args()
    print(f"Pipeline scaffold ready. seed={args.seed}, scale={args.scale}")
    print("Next implementation step: master data and transaction generators.")

if __name__ == "__main__":
    main()
