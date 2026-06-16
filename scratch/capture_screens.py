import subprocess
import re
import sys
import os
import time

def get_device_id():
    try:
        output = subprocess.check_output(["adb", "devices"]).decode("utf-8")
        lines = output.strip().split("\n")[1:]
        devices = [line.split()[0] for line in lines if line.strip() and "device" in line]
        if not devices:
            print("Error: No ADB devices found!")
            sys.exit(1)
        print(f"Found ADB devices: {devices}")
        return devices[0]
    except Exception as e:
        print(f"Error getting ADB devices: {e}")
        sys.exit(1)

def main():
    device_id = get_device_id()
    print(f"Using ADB device ID: {device_id}")

    # Ensure screenshots directory exists
    os.makedirs("./screenshots", exist_ok=True)

    # Grant permissions to avoid permission dialogs during tests
    package_name = "com.hn.visionsafe"
    print(f"Granting camera, system overlay, and notification permissions to {package_name}...")
    subprocess.run(["adb", "-s", device_id, "shell", "pm", "grant", package_name, "android.permission.CAMERA"])
    subprocess.run(["adb", "-s", device_id, "shell", "pm", "grant", package_name, "android.permission.POST_NOTIFICATIONS"])
    subprocess.run(["adb", "-s", device_id, "shell", "appops", "set", package_name, "SYSTEM_ALERT_WINDOW", "allow"])

    # Start the flutter integration test with stdout piped so we can parse it in real-time
    cmd = [
        "/home/irsyad/sdk/flutter/bin/flutter",
        "test",
        "integration_test/app_test.dart",
        "-d",
        device_id
    ]
    print(f"Running command: {' '.join(cmd)}")
    
    test_process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)

    screenshot_pattern = re.compile(r"TAKE_SCREENSHOT:\s*(\w+)")
    done_pattern = re.compile(r"TAKE_SCREENSHOT_DONE")

    print("Monitoring flutter test output for screenshot triggers...")

    try:
        while True:
            line = test_process.stdout.readline()
            if not line:
                # Check if process has terminated
                if test_process.poll() is not None:
                    break
                time.sleep(0.1)
                continue

            # Forward output to console in real-time
            sys.stdout.write(line)
            sys.stdout.flush()

            # Check for screenshot trigger in stdout line
            match = screenshot_pattern.search(line)
            if match:
                screenshot_name = match.group(1)
                print(f"\n[Automation] Trigger detected for: {screenshot_name}. Waiting 2s for UI stability...")
                time.sleep(2.0)
                
                # Execute screencap
                cap_cmd = ["adb", "-s", device_id, "shell", "screencap", "-p", "/sdcard/vizo_screen.png"]
                subprocess.run(cap_cmd)
                
                # Pull screenshot
                local_path = f"./screenshots/screenshot_{screenshot_name}.png"
                pull_cmd = ["adb", "-s", device_id, "pull", "/sdcard/vizo_screen.png", local_path]
                subprocess.run(pull_cmd)
                
                print(f"[Automation] Captured and saved to: {local_path}\n")

            if done_pattern.search(line):
                print("[Automation] Detected TAKE_SCREENSHOT_DONE.")

    except KeyboardInterrupt:
        print("Monitoring interrupted.")
    finally:
        # Ensure process is terminated
        test_process.terminate()

    print("Integration test and screenshot automation finished.")

if __name__ == "__main__":
    main()
