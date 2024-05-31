# Migration Instructions for the DIG Team

## Introduction
This document directs macOS users on how to remove conda from their systems while retaining some partial backups of existing environments.

## Removing conda
1. Find your conda installation location
    1. If you don't have a conda environment active, run 
        ```sh
        conda activate base
        ```
    1. Run
        ```sh
        which python
        ```
    1. Save your conda installation location from that outupt.
        For example, for me, it was `/Users/jbaruch/miniconda3/envs/dig_core/bin/python`. This means my conda installation location is `/Users/jbaruch/miniconda3`
    1. :warning:  **IF YOUR INSTALLATION LOCATION DOES NOT HAVE THE TERM `CONDA` IN IT REACH OUT TO JOEY AND DO NOT CONTINUE** :warning: 
1. back up your current environment installation versions. 
    ```sh
    cd <a location where you want to put the backups>
    ```
    <details>
    <summary> :arrow_right:  copy-paste and run the below code in your zsh terminal (click to expand) </summary> 

    ```sh
    cat << 'EOF' > backup_active_conda_env.sh
    #!/bin/bash
    
    # Function to display help message
    function show_help() {
      echo "Usage: $0 -b [backup_directory]"
      echo "   -b backup_directory: The directory where you want to save the backups."
    }
    
    # Initialize variables
    backup_dir=""
    
    # Parse command-line options
    while getopts ":b:h" opt; do
      case ${opt} in
        b )
          backup_dir=$OPTARG
          ;;
        h )
          show_help
          exit 0
          ;;
        \? )
          echo "Invalid option: $OPTARG" 1>&2
          show_help
          exit 1
          ;;
        : )
          echo "Invalid option: $OPTARG requires an argument" 1>&2
          show_help
          exit 1
          ;;
      esac
    done
    
    # Check if backup directory was provided
    if [ -z "$backup_dir" ]; then
      echo "Error: Backup directory not provided."
      show_help
      exit 1
    fi
    
    # Create backup directory if it does not exist
    mkdir -p $backup_dir
    if [[ ! -d $backup_dir ]]; then
      echo "Failed to create directory: $backup_dir"
      exit 1
    fi
    
    # Confirm that a Conda environment is active
    if [ -z "$CONDA_DEFAULT_ENV" ]; then
      echo "No Conda environment is active."
      exit 1
    fi
    
    # Export the active Conda environment
    echo "Exporting active Conda environment ${CONDA_DEFAULT_ENV}..."
    conda env export > $backup_dir/${CONDA_DEFAULT_ENV}_env.yml || { echo "Failed to export active Conda environment"; exit 1; }
    
    # Export pip requirements
    echo "Exporting pip packages..."
    pip freeze > $backup_dir/${CONDA_DEFAULT_ENV}_pip_requirements.txt || { echo "Failed to export pip packages"; exit 1; }
    
    # Optionally backup Conda configuration
    echo "Backing up Conda configuration..."
    conda config --show > $backup_dir/${CONDA_DEFAULT_ENV}_conda_config.txt || { echo "Failed to backup Conda configuration"; exit 1; }
    
    echo "Backup completed. All environment details saved to $backup_dir"
    EOF
    chmod +x backup_active_conda_env.sh
    conda env list | awk '{print $1}' | grep -v '^#' | while read env; do conda activate "$env"; ./backup_active_conda_env.sh -b "./conda_backups"; conda deactivate; done
    ```

    </details>

    ```
    This will create backup files in case you latter need to figure out all the specific versions of your dependencies, any configurations, or other packages. It'll create a directory called `conda_backups` and put them all there.
    ```

1.  Clean up all your conda environments
    ```sh
    conda env list | awk '{print $1}' | grep -v '^#' | while read env; do conda activate "$env"; conda install -y anaconda-clean; anaconda-clean --yes; conda deactivate; done
    rm -r ~/.anaconda_backup
    ```
1. :warning: This stage is a little more high touch - Remove your conda installation directory (using the location collected before) and references.
    1. Look for conda references in your zshrc or bashrc
        ```sh
        cat ~/.zshrc | grep conda
        cat ~/.bashrc | grep conda
        cat ~/.bash_profile | grep conda
        ```
    1. If you found conda references in one, then use `conda init --reverse <shell>` to attempt to remove them. For example, if you got for zsh:
        ```bash
        conda init --reverse zsh
        ```
    1. Check again, if you still have `conda` references and you feel you know how to clean them up - do so. Otherwise, ask for help **BEFORE MOVING FORWARD**
    1. Remove conda installation :warning: **IF THIS LOCATION DOES NOT HAVE THE WORD `CONDA` IN IT - STOP** :warning: 
        ```bash
        rm -rf <your conda installation location>
        ```
