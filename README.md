# Transfer Entropy Analysis for Auditory and Visual Naming Tasks

This repository contains MATLAB scripts for Transfer Entropy (TE) analysis and movie generation for auditory and visual naming tasks.

All TE-related scripts are located in:

```text
Code/TE
```

The sample data used for testing the TE pipeline are located in:

```text
Positive_AUD/TE1
```

---

## Requirements

This analysis requires MATLAB and the following external dependencies.

### External dependencies

The following dependencies are not included in this repository and must be downloaded separately by each user.

1. **FieldTrip**

   FieldTrip is an external MATLAB-based software package for electrophysiological and neuroimaging data analysis.

   Download:  
   https://www.fieldtriptoolbox.org/

2. **fsaverage**

   `fsaverage` is the standard cortical surface/template directory distributed with FreeSurfer.

   It is required for cortical surface visualization and anatomical mapping.

   FreeSurfer:  
   https://surfer.nmr.mgh.harvard.edu/

---

## Folder Structure

Please place the repository under the `C:\` drive on your local machine.

The expected folder structure is:

```text
C:\
└── WholeBrain_TE_Naming\
    ├── Code\
    │   ├── TE\
    │   ├── FieldTrip\
    │   └── fsaverage\
    ├── Positive_AUD\
    │   └── TE1\
    └── README.md
```

Please place the external dependencies as follows:

```text
C:\WholeBrain_TE_Naming\Code\FieldTrip
C:\WholeBrain_TE_Naming\Code\fsaverage
```

---

## Main Scripts

### Transfer Entropy calculation

```text
Code/TE/TE_run.m
```

`TE_run.m` is the MATLAB script for performing the Transfer Entropy calculation.

### Movie generation for the Auditory Naming Task

```text
Code/TE/TE_M_movie_PN_AUD.m
```

`TE_M_movie_PN_AUD.m` is the MATLAB script for generating movies for the Auditory Naming Task.

### Movie generation for the Visual Naming Task

```text
Code/TE/TE_M_movie_PN_VIS.m
```

`TE_M_movie_PN_VIS.m` is the MATLAB script for generating movies for the Visual Naming Task.

---

## Running the Example Analysis

The sample data are located in:

```text
Positive_AUD/TE1
```

To run the example TE analysis, start MATLAB and run:

```matlab
repoDir = 'C:\WholeBrain_TE_Naming';

addpath(genpath(fullfile(repoDir, 'Code', 'TE')));

addpath(fullfile(repoDir, 'Code', 'FieldTrip'));
ft_defaults;

cd(fullfile(repoDir, 'Code', 'TE'));

TE_run;
```

After the TE calculation is complete, movies can be generated using:

```matlab
TE_M_movie_PN_AUD;
```

or

```matlab
TE_M_movie_PN_VIS;
```

---

## Notes

FieldTrip and fsaverage are external dependencies and are not redistributed with this repository.

FieldTrip should be placed under:

```text
Code/FieldTrip
```

fsaverage should be placed under:

```text
Code/fsaverage
```
