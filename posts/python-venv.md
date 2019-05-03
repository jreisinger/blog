## Python3 virtual environment

A virtual environment is a copy of the Python interpreter into which you can
install packages without affecting the global system Python.

```
# install the venv package
sudo apt-get install python3-venv

# create a virtual environment (will fail if already exists)
python3 -m venv venv # 'venv' is a common name for a virtual environment
```

```
# activate the virtual environment
source venv/bin/activate

# install packages into the virtual environment
pip install -r requirements.txt
pip install flask
```

```
# check installed package
pip freeze [>requirements.txt]
```

```
# deactivate the virtual environment
deactivate
```

You can safely .gitignore the virtual environment folder:

```
$ cat .gitignore 
.*
!/.gitignore
venv
__pycache__
```
