# Docs
https://github.com/sinaatalay/rendercv

# Install
## Python
```shell
brew install python
brew install pipx
```
## venv
Active the virtual environment:
```shell
source venv/bin/active 
```

## packages
```shell
pip3 install -r requirements.txt
```

# Usage

## Init CV
Creates the starting input files - Edit "Harvey_Mackie_CV.yaml" 
```shell
$ rendercv new "Harvey Mackie"
The following RenderCV input file and folders have been created:
Harvey_Mackie_CV.yaml,
classic,
markdown
```

## Generate CV
```shell
$ rendercv render Harvey_Mackie_CV.yaml
```


