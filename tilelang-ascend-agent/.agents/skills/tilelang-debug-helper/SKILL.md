---
name: tilelang-debug-helper
description: How to add debugging capabilities to TileLang Ascend example operators. Use this skill whenever the user asks to debug a TileLang example, add GDB debugging code, create a debug version of an example, or mentions GDB, debugging, breakpoints, or VSCode debugging in the context of TileLang operators. This skill covers adding debug code to Python examples, configuring CMakeLists.txt for C++ debugging, and setting up VSCode for Python + C++ joint debugging.
---

# TileLang Debug Helper

This skill helps you add debugging capabilities to TileLang Ascend example operators so they can be debugged with GDB in VSCode.

## Overview

Debugging TileLang examples involves three main components:
1. **Python Debug Code**: Add PID printing and wait logic to Python examples
2. **C++ Debug Build**: Configure CMakeLists.txt to preserve debug symbols
3. **VSCode Configuration**: Set up joint Python + C++ debugging environment

## When to Use This Skill

Use this skill when:
- User asks to "debug" or "add debugging code" to a TileLang example
- User mentions GDB, breakpoints, or VSCode debugging
- User wants to step through C++ code in a TileLang operator
- User needs to inspect variables or execution flow in a TileLang kernel
- User wants to set up the complete debugging environment

---

## Part 1: Adding Debug Code to Python Examples

### Understanding the Task

When a user wants to debug a TileLang example, they need to:
1. Add code to print the process ID (PID)
2. Add code to wait for GDB attachment
3. This allows attaching a GDB debugger to the running Python process

### Step 1: Read the Original Example

First, read the example file that needs debugging. These are typically located in the `examples/` directory and end with `.py`.

### Step 2: Identify the Right Location

Find the best place to insert the debugging code. Look for:
- After imports and before the main test execution
- Before the function is called with `@tilelang.jit`
- After `torch.manual_seed()` if present
- Before the test loop starts

The goal is to pause execution before the actual kernel runs, so GDB can be attached.

### Step 3: Add Debug Code

Insert the following code at the identified location:

```python
import os

# Debug: Print PID and wait for GDB attachment
print(f"PID: {os.getpid()}")
input("Press Enter after attaching GDB...")
```

**Important:**
- Make sure `import os` is at the top of the file (or add it if not present)
- Place this code BEFORE the kernel execution, not inside the kernel function
- The `input()` call will pause execution, giving time to attach GDB

### Step 4: Save the Debug Version

Save the modified file. Common naming conventions:
- Add `_debug` suffix: `sigmoid_debug.py`
- Or keep the original name if replacing it

### Complete Example

Here's how a debug version should look:

```python
import os
import tilelang
import tilelang.language as T
import torch

tilelang.cache.clear_cache()

@tilelang.jit(out_idx=[1])
def sigmoid(M, N, block_M, block_N, dtype="float"):
    # ... kernel implementation ...
    pass

torch.manual_seed(0)

# Debug: Print PID and wait for GDB attachment
print(f"PID: {os.getpid()}")
input("Press Enter after attaching GDB...")

# Test execution
test_configs = [(256, 256, 64, 64)]
for M, N, block_M, block_N in test_configs:
    func = sigmoid(M, N, block_M, block_N)
    a = torch.randn(M, N).npu()
    b = func(a)
    # ... assertions ...
```

### Common Patterns

#### Pattern 1: Simple Example with Single Test

For examples with a simple structure:
- Add debug code after imports and setup
- Before the function call

#### Pattern 2: Multiple Test Configurations

For examples with multiple test cases:
- Add debug code before the test loop
- This allows debugging any of the test cases

#### Pattern 3: Examples with Multiple Functions

For examples with multiple kernel functions:
- Add debug code before the first function call
- User can set breakpoints in specific functions

---

## Part 2: Configuring CMakeLists.txt for C++ Debugging

### Understanding the Requirement

To debug C++ code in TileLang, the project must be compiled with:
- Debug symbols (`-g`)
- No optimizations (`-O0`)

This allows GDB to properly inspect variables and step through code.

### Step 1: Locate CMakeLists.txt

The file is located at: `tilelang-ascend/CMakeLists.txt`

### Step 2: Find the Target Library

Search for the line:
```cmake
add_library(tilelang_objs OBJECT ${TILE_LANG_SRCS})
```

### Step 3: Add Debug Compilation Options

Add the following line immediately after the `add_library` line:
```cmake
target_compile_options(tilelang_objs PRIVATE -g -O0)
```

### Complete Example

```cmake
# ... previous content ...

add_library(tilelang_objs OBJECT ${TILE_LANG_SRCS})
target_compile_options(tilelang_objs PRIVATE -g -O0)

# ... rest of the file ...
```

### Step 4: Build the Project

After modifying CMakeLists.txt, build the project to apply the changes:

First, check if the `build` directory exists:

```bash
# Check if build directory exists
if [ -d "build" ]; then
    echo "build directory exists, rebuilding..."
    cd build
    cmake ..
    make -j$(nproc)
else
    echo "build directory does not exist, running install_ascend.sh..."
    bash install_ascend.sh
fi
```

Or manually:

```bash
# If build directory exists
cd build
cmake ..
make -j$(nproc)

# If build directory does NOT exist
bash install_ascend.sh
```

---

## Part 3: Configuring VSCode for Python + C++ Joint Debugging

### Understanding the Setup

VSCode needs two configurations:
1. **Python Debug Configuration**: Launches the Python script with debugpy
2. **C++ GDB Attach Configuration**: Attaches GDB to the running Python process

This allows seamless debugging across Python and C++ code.

### Step 1: Check/Create .vscode Directory

```bash
mkdir -p .vscode
```

### Step 2: Configure launch.json

Create or merge `.vscode/launch.json` with the following configurations:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Debug Ascend Kernel",
            "type": "debugpy",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "justMyCode": false,
            "preLaunchTask": "set env",
            "envFile": "${workspaceFolder}/.env"
        },
        {
            "name": "Step 2: Attach C++ (GDB)",
            "type": "cppdbg",
            "request": "attach",
            "program": "/usr/local/bin/python",
            "processId": "${command:pickProcess}",
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}
```

### Step 3: Configure tasks.json

Create or merge `.vscode/tasks.json` with the following task:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "set env",
            "type": "shell",
            "command": "source /mnt/workspace/tilelang/tilelang-ascend/set_env.sh && env > ${workspaceFolder}/.env",
            "problemMatcher": []
        }
    ]
}
```

### Step 4: Install Required VSCode Extensions

Ensure the following extensions are installed:
- Python: `ms-python.python`
- C/C++: `ms-vscode.cpptools`

---

## Part 4: Using Virtual Environment for Python Debugging

### Step 1: Create Virtual Environment

If not already created, create a virtual environment in the project root:

```bash
cd /mnt/workspace/tilelang/tilelang-ascend
python -m venv .venv
```

### Step 2: Activate Virtual Environment

```bash
source .venv/bin/activate
```

### Step 3: Install Dependencies

```bash
pip install -e .
pip install debugpy
```

### Step 4: Update VSCode to Use Virtual Environment

VSCode will automatically detect the `.venv` directory and use it for Python debugging. No manual configuration needed.

---

## Complete Debugging Workflow

### Step-by-Step Guide

1. **Configure CMakeLists.txt** (if not already done)
   - Add `target_compile_options(tilelang_objs PRIVATE -g -O0)`

2. **Set Up Up Virtual Environment** (if not already done)
   - Create `.venv` virtual environment
   - Activate and install dependencies

3. **Build the Project** (if not already built or after CMakeLists.txt changes)
   - Check if `build` directory exists
   - If `build` directory does NOT exist, run `bash install_ascend.sh` to build the project
   - If `build` directory exists, run:
     ```bash
     cd build
     cmake ..
     make -j$(nproc)
     ```

4. **Configure VSCode** (if not already done)
   - Create `.vscode/launch.json` and `.vscode/tasks.json`
   - Install required extensions

5. **Add Debug Code to Python Example**
   - Insert PID printing and wait logic
   - Save the file

6. **Start Debugging**
     - **Method 1: Command Line Debugging (Recommended)**
       - In VSCode terminal, run the following command (do NOT execute it, just provide to user):
         ```bash
         source set_env.sh
         python -m debugpy --listen 5678 examples/activation/sigmoid.py
         ```
       - The script will print the PID and pause
       - Run "Step 2: Attach C++ (GDB)"
       - Select the Python process when prompted
       - Set breakpoints in C++ code
       - Press Enter in the Python console to continue execution
       - GDB will hit breakpoints in C++ code
     
     - **Method 2: VSCode F5 Debugging (Alternative)**
       - Open the Python example in VSCode
       - Run "Python: Debug Ascend Kernel" (F5)
       - The script will print the PID and pause
       - Run "Step 2: Attach C++ (GDB)"
       - Select the Python process when prompted
       - Set breakpoints in C++ code
       - Press Enter in the Python console to continue execution
       - GDB will hit breakpoints in C++ code

### Alternative: Terminal Debugging with debugpy

You can also debug from the terminal (provide command to user, do NOT execute):

```bash
# Activate virtual environment
source .venv/bin/activate

# Start Python with debugpy listener
python -m debugpy --listen 5678 examples/activation/sigmoid.py
```

Then in VSCode:
1. Create a new debug configuration:
```json
{
    "name": "Python: Attach to debugpy",
    "type": "debugpy",
    "request": "attach",
    "connect": {
        "host": "localhost",
        "port": 5678
    },
    "pathMappings": [
        {
            "localRoot": "${workspaceFolder}",
            "remoteRoot": "${workspaceFolder}"
        }
    ]
}
```

2. Run the "Python: Attach to debugpy" configuration
3. Set breakpoints and debug as usual

### What Happens During Debugging

1. User runs the Python script with debug code
2. Script prints PID and pauses at `input()`
3. User attaches GDB to that PID in VSCode
4. User presses Enter in the Python console
5. Execution continues and GDB can hit breakpoints in C++ code
6. User can step through both Python and C++ code seamlessly

---

## Verification

### After Adding Debug Code to Python

1. Verify the file is syntactically correct
2. Confirm `import os` is present
3. Confirm the debug code is placed before kernel execution
4. The file should run and pause at the `input()` call

### After Modifying CMakeLists.txt

1. Verify the `target_compile_options` line is present
2. Rebuild the project successfully
3. Debug symbols are present in the compiled binaries

### After Configuring VSCode

1. Verify `.vscode/launch.json` exists and is valid JSON
2. Verify `.vscode/tasks.json` exists and is valid JSON
3. Verify `set_env.sh` path is correct in tasks.json
4. Verify `.env` file is generated when running "set env" task

### After Setting Up Virtual Environment

1. Verify `.venv` directory exists
2. Verify `debugpy` is installed: `pip list | grep debugpy`
3. Verify Python interpreter is set to `.venv/bin/python`

---

## Troubleshooting

### Python Debug Code Issues

**Problem**: Script doesn't pause at `input()`
- **Solution**: Ensure debug code is placed before kernel execution, not inside the kernel function

**Problem**: `import os` not found
- **Solution**: Add `import os` at the top of the file

### C++ Debugging Issues

**Problem**: Breakpoints don't work in C++ code
- **Solution**: 
  - Verify `target_compile_options(tilelang_objs PRIVATE -g -O0)` is in CMakeLists.txt
  - Rebuild the project after modifying CMakeLists.txt
  - Ensure GDB is installed: `sudo apt install gdb`

**Problem**: Can't inspect variables in GDB
- **Solution**: Ensure the project is compiled with `-g` flag

### VSCode Configuration Issues

**Problem**: "Python: Debug Ascend Kernel" fails
- **Solution**:
  - Install Python extension: `ms-python.python`
  - Verify `set_env.sh` path is correct in tasks.json
  - Check that `.env` file is generated
  - Ensure virtual environment is activated

**Problem**: "Step 2: Attach C++ (GDB)" fails
- **Solution**:
  - Install C/C++ extension: `ms-vscode.cpptools`
  - Ensure GDB is installed: `sudo apt install gdb`
  - Verify the Python process is running when attaching

**Problem**: Can't find the Python process
- **Solution**: 
  - Run the Python debug configuration first
  - Wait for the PID to be printed
  - Then attach GDB

### Virtual Environment Issues

**Problem**: VSCode doesn't use virtual environment
- **Solution**:
  - Ensure `.venv` directory is in the project root
  - Restart VSCode
  - Manually select interpreter: `Ctrl+Shift+P` → "Python: Select Interpreter"

**Problem**: debugpy not found
- **Solution**:
  - Activate virtual environment: `source .venv/bin/activate`
  - Install debugpy: `pip install debugpy`

---

## Output

Always provide:
- The path to the created/modified debug file (if applicable)
- Brief instructions on how to use it (run, attach GDB, continue)
- Mention any additional setup needed if not already done
- Clear steps for the complete debugging workflow with correct order:
  1. Configure CMakeLists.txt (add -g -O0)
  2. Set up virtual environment (create .venv, activate, install dependencies)
  3. Build the project (check if build directory exists, if not run install_ascend.sh, otherwise cd build && cmake .. && make -j$(nproc))
  4. Configure VSCode (create .vscode/launch.json and .vscode/tasks.json)
  5. Add debug code to Python example
  6. Start debugging in VSCode

---

## Prerequisites Summary

Before starting debugging, ensure:
- Linux operating system
- Git installed
- Python 3.10 or higher
- GDB installed (`sudo apt install gdb`)
- VSCode with Python and C/C++ extensions
- TileLang project compiled with debug information
- CMakeLists.txt configured with `-g -O0`
- VSCode configured with launch.json and tasks.json
- Virtual environment `.venv` created and activated
- debugpy installed in virtual environment
