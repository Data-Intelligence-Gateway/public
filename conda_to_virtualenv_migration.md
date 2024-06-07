# DIG conda -> virtualenv Migration Plan

## Introduction
This document is to guide DIG team members on how to migrate from conda to virtualenv. The migration is a decision followed by internal reasons, and evaluation of multiple options.

It's important to note that this is a simple change, and this document is meant to detail the changes.

## Evaluated Options
* virtualenv
* venv
* poetry

#### Target: virtualenv
#### Reason
while venv is packaged with most python version, virtualenv can facilitate creation of environments with muliple python versions, which we've done in the past

#### Validation
1. Searching for hard dependencies of dig_core on `conda` or `conda-forge`: None found.
1. Operationalizing 

### Other Targets
<details>
<summary> :arrow_right: (click to expand) </summary>

**Venv** - lack of cross-version support causes lean out of this solution

**Poetry** - this would have been AMAZING if we didn't already have a build flow. Poetry  provides hollistic virtualization, package managemt, build and release support, but that would require us to migrate both our `dig_core` build system (`setup.py`) as well as our github actions (`PR tests`, `post_merge_versioning`, `artifactory_release`) and our artifactory integraion (`~/.pip.pip.conf`).

</details>

## Change Management
### What stays the same
1. virtualenv creates virtual envrionments just like conda created conda environments
1. you must still activate/deactivate environments in your execution context (terminal, IDE, etc). An activated environment is still only good for the context it was activated in e.g. if you activate an environment in your terminal, it won't be activated in your IDE or in a different terminal.
1. you can still use virtualenv to create environments with different python versions
1. your system will still rely on the exisitng `~/.pip/pip.conf` file for artifactory integration
1. you can still `pip install` packages into your environment

### What changes
1. the location of these environments is no longer some centralized location like `/opt/miniconda/envs/...` but rather environments are created in the local directory you called virtualenv from by default.
    1. For example, the dig_core `venv` environment would be created in the same directory as the `dig_core` repository.
    1. This has some implications, including that it's a little harder to share environments between projects, but it also means that you can have multiple environments for the same project.
    1. The IDEs will be able to identify the local virtual environments and load them if they are there upon boot.
1. Conda used to manage the base python versions. Now we must manage the base python versions ourselves. 

## virtualenv Setup
:warning: **Note**: This guide assumes you don't have another virtual environment manager installed. If you do, you may need to uninstall it or modify the instructions accordingly.

### Base python3's
1. Validate or install a base python on your mac
    1. If the below points to a python installation, you can use it.
        ```sh
        which python3
        ```
    1. If you did not have a base python3 installation, you can [download from here](https://www.python.org/downloads/), or run
        ```sh
        brew install python
        ```
    1. Check for pipx installation
        ```sh
        which pipx
        ```
    1. If you do not have pipx, install it
        ```sh
        brew install pipx
        ```
1. Install any other python versions we'll need for any other environments
    1. Given that the DIG team uses python 3.8 and 3.9, and we want to keep the option to use further versions, we'll also install the versions we need.
        ```sh
        brew install python@3.8
        brew install python@3.9
        ```
### Installing virtualenv
You can follow [this guide](https://virtualenv.pypa.io/en/latest/installation.html) for installation instructions. The following is a summary of the steps.

1. Install virtualenv
    ```sh
    pipx install virtualenv
    virtualenv --version
    ```
1. If the previous command does not return a version, you may need to add the following to your `~/.zshrc` or `~/.bash_profile`

    1. You may already have customizations in your `~/.zshrc`, specially if you used [our custom zshrc additions](https://github.com/Data-Intelligence-Gateway/public/blob/main/.zshrc_additions). If you do, we recommend adding this line under
        ```sh
            # ### Helpful extra system settings
            # exit value is last non-zero (if anything in a pipe fails) or zero (if nothing fails). by default this is set to the value of the rightmost command (so fails in the pipe can happen silently)
            set -o pipefail 
            # if you've installed virtualenv:
            export PATH=$PATH:$HOME/.local/bin
        ```
    1. If you don't, it's recommended you review them and consider editing your `~/.zshrc`.
    1. Otherwise, please make sure to add the following to your shell profile
        ```sh
        export PATH=$PATH:$HOME/.local/bin
        ```
    1. Reload your shell profile
        ```sh
        source ~/.zshrc
        ```
    1. Validate the installation
        ```sh
        virtualenv --version
        ```
### Creating a virtual environment
See the virtualenv user guide [here](https://virtualenv.pypa.io/en/latest/user_guide.html)

#### PyCharm Method
PyCharm's comes with a built-in virtual environment manager. You can create a virtual environment by following [this guide](https://www.jetbrains.com/help/pycharm/creating-virtual-environment.html#env-requirements)

Once you create the venv, you'll notice a new folder named `venv` in your project directory. This is where the virtual environment is stored.

You may need to restart pycharm for it to pick up the new virtual environment.

:warning: It's important to make sure to select a python version that's managed by homebrew (if you followed this guide). 

#### VSCode Method
While vs code does have a built-in virtual environment manager, it's using `venv` instead of `virtualenv`. You can use that, but it's recommended to use `virtualenv` for consistency. See below for the CLI method.

Once you've created a virtual environment via CLI (or any other method), you can restart your vs code and it should pick up the virtual environment.

:warning: It's important to make sure to select a python version that's managed by homebrew (if you followed this guide).

Still, if you want to continue with vs code's built-in, you can create a virtual environment by following [this guide](https://code.visualstudio.com/docs/python/environments#_select-and-activate-an-environment)

#### CLI Method
1. Create a virtual environment
    ```sh
    cd /path/to/dig_core
    virtualenv venv -p python3.9
    ```
    You can use any name for the `venv` folder, but this is a common convention.
    Note that the `-p python3.9` flag is optional. If you don't specify a python version, it will use the same python3 version you'd get with `which python3`.
1. Activate the virtual environment
    ```sh
    source .venv/bin/activate
    ```
1. Validate the python version - :warning: This step is important to ensure you're using the correct python version before installing dependencies
    ```sh
    python --version
    ```
1. Install dependencies
    ```sh
    pip install -r requirements.txt
    ```
1. Deactivating the virtual environment is easy
    ```sh
    deactivate
    ```
    
