# stm8-sdcc-template
Template setup for STM8 projects using the [SDCC - Small Device C Compiler](https://sdcc.sourceforge.net/). Feel free to modify it for [other microcontrollers supported by SDCC](https://sdcc.sourceforge.net/doc/sdccman.pdf)

Loading the program onto the microcontroller can be done using either:
- STVP (on Windows) or 
- [stm8flash](https://github.com/vdudouyt/stm8flash.git) (on MAC or LINUX)

## References
- [stm8s-sdcc-template](https://github.com/neosarchizo/stm8-sdcc-template.git)

# Setup
Microcontroller program can compiled either on the host computer (Windows, Linux, Mac) or using a Docker DevContainer.

Compiled program can be flashed onto the microcontroller using either [stm8flash](https://github.com/vdudouyt/stm8flash.git) (on MAC or LINUX) or using the ST Visual Programmer (STVP) on Windows.

A detailed workthrough can be seen on YouTube

1. ## Windows

    Requirements:
    - [ST Toolset](https://www.st.com/en/development-tools/stvd-stm8.html) includes ST Visual Develop (STVD) IDE and ST Visual Programmer (STVP)
    - [STM8CubeMX](https://www.st.com/en/development-tools/stm8cubemx.html) (Optional)
    - [Cosmic STM8 Compiler](https://www.cosmicsoftware.com/download_stm8_free.php) (Optional)
    - [SDCC](https://sdcc.sourceforge.net/snap.php) - Small Device C Compiler (Optional)
    - [Docker](https://www.docker.com/) (Optional)
    - [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (Optional)

2. ## Linux
