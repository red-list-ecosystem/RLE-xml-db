# Jupyter Lab

These are the steps I followed to configure a Jupyter Lab environment.

## Conda
Create a new environment with conda:

```sh
conda create --name jptr
```

Activate the environment and install R (with RPostgreSQL package) and jupyter lab:

```{bash}
conda activate jptr
conda install -c conda-forge r-rpostgresql r-readxl devtools
conda install -c conda-forge jupyterlab
```

Activate the right R kernel...
```{r}
#R --vanilla
IRkernel::installspec()
```

Install python libraries with pip

```{bash}
pip install openpyxl psycopg2-binary
pip install pandas SQLAlchemy
pip install pybtex
#pip install postgis
```

Install python libraries for working with google docs:

```{bash}
pip install google_spreadsheet
pip install google-auth-oauthlib

```

Start the jupyter lab interface:
```sh
cd ~/proyectos/IUCN-RLE/RLE-xml-db
conda activate jptr
jupyter-lab
```
