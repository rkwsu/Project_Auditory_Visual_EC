# Whole-Brain Transfer Entropy Analysis for Auditory and Visual Naming Tasks

This repository contains MATLAB scripts for calculating and visualizing whole-brain directional information flow during auditory and visual naming tasks using Transfer Entropy (TE).

The TE-related scripts are located in:

```text
Code/TE
```

A sample dataset for testing the pipeline is provided in:

```text
Positive_AUD/TE1
```

The sample data can be used to confirm that the code and required external dependencies are installed correctly.

---

## 1. Overview

This repository includes scripts for:

1. Performing Transfer Entropy calculation.
2. Generating TE-based movies for the Auditory Naming Task.
3. Generating TE-based movies for the Visual Naming Task.

The main scripts are:

```text
Code/TE/TE_run.m
Code/TE/TE_M_movie_PN_AUD.m
Code/TE/TE_M_movie_PN_VIS.m
```

`TE_run.m` performs the Transfer Entropy calculation.

`TE_M_movie_PN_AUD.m` generates movies for the Auditory Naming Task.

`TE_M_movie_PN_VIS.m` generates movies for the Visual Naming Task.

---

## 2. Required Software and External Dependencies

### Required software

- MATLAB

### Required external dependencies

The following external dependencies are required but are **not included** in this repository.

Each user must download these dependencies separately and place them in the required folders before running the analysis.

1. FieldTrip

   FieldTrip is an external MATLAB-based software package for electrophysiological and neuroimaging data analysis.

   FieldTrip is not included in this repository.

   Download FieldTrip from:

   ```text
   https://www.fieldtriptoolbox.org/
   ```

2. fsaverage

   `fsaverage` is the standard cortical surface/template directory distributed with FreeSurfer.

   `fsaverage` is not included in this repository.

   It is required for cortical surface visualization and anatomical mapping.

   FreeSurfer website:

   ```text
   https://surfer.nmr.mgh.harvard.edu/
   ```

---

## 3. Recommended Folder Structure

Please place the repository folder directly under the `C:\` drive on your local machine.

For example:

```text
C:\
└── WholeBrain_TE_Naming\
    ├── Code\
    │   ├── TE\
    │   │   ├── TE_run.m
    │   │   ├── TE_M_movie_PN_AUD.m
    │   │   ├── TE_M_movie_PN_VIS.m
    │   │   └── other TE-related scripts and functions
    │   ├── FieldTrip
    │   └── fsaverage
    ├── Positive_AUD\
    │   └── TE1
    └── README.md
```

The required external dependencies should be placed here:

```text
C:\WholeBrain_TE_Naming\Code\FieldTrip
C:\WholeBrain_TE_Naming\Code\fsaverage
```

Please make sure that the folder names are exactly:

```text
FieldTrip
fsaverage
```

The scripts assume that these external dependencies are located under the `Code` directory.

---

## 4. Installation Instructions

### Step 1. Download or clone this repository

Place the repository folder directly under the `C:\` drive.

Example:

```text
C:\WholeBrain_TE_Naming
```

---

### Step 2. Download FieldTrip

Download FieldTrip separately from:

```text
https://www.fieldtriptoolbox.org/
```

After downloading and extracting FieldTrip, place the FieldTrip folder here:

```text
C:\WholeBrain_TE_Naming\Code\FieldTrip
```

The folder should contain files such as:

```text
ft_defaults.m
ft_read_header.m
ft_read_data.m
```

---

### Step 3. Prepare fsaverage

Obtain the `fsaverage` directory from a FreeSurfer installation.

Place the `fsaverage` folder here:

```text
C:\WholeBrain_TE_Naming\Code\fsaverage
```

The folder should contain standard FreeSurfer fsaverage files and subdirectories.

For example:

```text
C:\WholeBrain_TE_Naming\Code\fsaverage\surf
C:\WholeBrain_TE_Naming\Code\fsaverage\label
C:\WholeBrain_TE_Naming\Code\fsaverage\mri
```

---

## 5. MATLAB Path Setup

Start MATLAB.

Set the repository directory:

```matlab
repoDir = 'C:\WholeBrain_TE_Naming';
```

Add the TE scripts to the MATLAB path:

```matlab
addpath(genpath(fullfile(repoDir, 'Code', 'TE')));
```

Add FieldTrip to the MATLAB path and initialize FieldTrip:

```matlab
addpath(fullfile(repoDir, 'Code', 'FieldTrip'));
ft_defaults;
```

Important:

Do not add FieldTrip using `genpath`.  
Use:

```matlab
addpath(fullfile(repoDir, 'Code', 'FieldTrip'));
ft_defaults;
```

FieldTrip manages its own subdirectories after `ft_defaults` is executed.

The `fsaverage` directory does not usually need to be added to the MATLAB path, but it must be located in:

```text
C:\WholeBrain_TE_Naming\Code\fsaverage
```

because the visualization scripts expect the template directory to be available there.

---

## 6. Example Analysis Using Sample Data

The sample data is located in:

```text
Positive_AUD/TE1
```

The full path should be:

```text
C:\WholeBrain_TE_Naming\Positive_AUD\TE1
```

To run the example TE analysis, start MATLAB and execute:

```matlab
repoDir = 'C:\WholeBrain_TE_Naming';

addpath(genpath(fullfile(repoDir, 'Code', 'TE')));
addpath(fullfile(repoDir, 'Code', 'FieldTrip'));
ft_defaults;

cd(fullfile(repoDir, 'Code', 'TE'));

TE_run;
```

This runs the Transfer Entropy calculation using the sample data located in:

```text
C:\WholeBrain_TE_Naming\Positive_AUD\TE1
```

---

## 7. Movie Generation

After the TE calculation has been completed, movies can be generated using the movie-generation scripts.

### Auditory Naming Task

To generate movies for the Auditory Naming Task, run:

```matlab
TE_M_movie_PN_AUD;
```

Main script:

```text
Code/TE/TE_M_movie_PN_AUD.m
```

---

### Visual Naming Task

To generate movies for the Visual Naming Task, run:

```matlab
TE_M_movie_PN_VIS;
```

Main script:

```text
Code/TE/TE_M_movie_PN_VIS.m
```

---

## 8. Script Descriptions

### `TE_run.m`

Location:

```text
Code/TE/TE_run.m
```

Description:

This is the main script for performing the Transfer Entropy calculation.  
It calculates directional information flow between regions of interest based on task-related high-gamma activity.

---

### `TE_M_movie_PN_AUD.m`

Location:

```text
Code/TE/TE_M_movie_PN_AUD.m
```

Description:

This script generates TE-based movies for the Auditory Naming Task.

---

### `TE_M_movie_PN_VIS.m`

Location:

```text
Code/TE/TE_M_movie_PN_VIS.m
```

Description:

This script generates TE-based movies for the Visual Naming Task.

---

## 9. Expected Workflow

The expected workflow is:

```text
1. Place the repository under C:\.
2. Download FieldTrip separately.
3. Place FieldTrip under Code\FieldTrip.
4. Obtain fsaverage from FreeSurfer.
5. Place fsaverage under Code\fsaverage.
6. Start MATLAB.
7. Add Code\TE to the MATLAB path.
8. Add FieldTrip to the MATLAB path and run ft_defaults.
9. Run TE_run.m.
10. Generate movies using TE_M_movie_PN_AUD.m or TE_M_movie_PN_VIS.m.
```

---

## 10. Troubleshooting

### Error: `Undefined function or variable 'ft_defaults'`

This error indicates that FieldTrip has not been added correctly to the MATLAB path.

Please confirm that FieldTrip is located here:

```text
C:\WholeBrain_TE_Naming\Code\FieldTrip
```

Then run:

```matlab
addpath('C:\WholeBrain_TE_Naming\Code\FieldTrip');
ft_defaults;
```

---

### Error: FieldTrip functions cannot be found

Please confirm that the FieldTrip folder contains files such as:

```text
ft_defaults.m
ft_read_header.m
ft_read_data.m
```

If these files are missing, FieldTrip may not have been downloaded or extracted correctly.

---

### Error: `fsaverage` cannot be found

Please confirm that the `fsaverage` folder is located here:

```text
C:\WholeBrain_TE_Naming\Code\fsaverage
```

The folder name should be exactly:

```text
fsaverage
```

---

### Error: sample data cannot be found

Please confirm that the sample data is located here:

```text
C:\WholeBrain_TE_Naming\Positive_AUD\TE1
```

---

### Error: TE scripts cannot be found

Please confirm that all TE-related scripts are located in:

```text
C:\WholeBrain_TE_Naming\Code\TE
```

The following files should be present:

```text
TE_run.m
TE_M_movie_PN_AUD.m
TE_M_movie_PN_VIS.m
```

---

## 11. Notes on External Dependencies

FieldTrip and fsaverage are not redistributed with this repository.

FieldTrip must be downloaded separately from the FieldTrip website.

fsaverage must be obtained separately from a FreeSurfer installation.

These dependencies should be placed under the `Code` directory as described above.

---

## 12. Data and Code Availability

The TE-related MATLAB scripts are provided in this repository under:

```text
Code/TE
```

The sample data for testing the pipeline is provided under:

```text
Positive_AUD/TE1
```

External dependencies, including FieldTrip and fsaverage, are not included in this repository and must be downloaded separately by each user.
