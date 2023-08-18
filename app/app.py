import os
import time

def main():
    
    print("Starting application...")

    variable1 = os.environ.get("VARIABLE1", "Not Set")
    variable2 = os.environ.get("VARIABLE2", "Not Set")

    while True:
        print("VARIABLE1:", os.environ.get("VARIABLE1", "Not Set"))
        print("VARIABLE2:", os.environ.get("VARIABLE2", "Not Set"))
        time.sleep(10)  # Pause for 10 seconds before printing again

    print("Ending application...")

if __name__ == "__main__":
    main()

