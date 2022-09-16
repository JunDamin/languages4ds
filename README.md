init file

``` 
install vscode extension
quarto
julia 

```
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.1.245/quarto-1.1.245-linux-amd64.deb
sudo dpkg -i quarto-1.1.245-linux-amd64.deb   
quarto install tool tinytex
```

```
# install julia

wget https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.1-linux-x86_64.tar.gz
tar zxvf julia-1.8.1-linux-x86_64.tar.gz
sudo cp -r julia-1.8.1 /opt/
sudo ln -s /opt/julia-1.8.1/bin/julia /usr/bin/julia
```


```
# install R

or you can use R container.

sudo vi /etc/apt/sources.list
```

and add next line
```
deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/
```

and register key and install r

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo apt update
sudo apt install r-base
sudo apt install r-base-dev
sudo apt install libcurl4-openssl-dev libssl-dev libxml2-dev

``` 

and run R and install.packages(")
```
sudo R
install.packages(c("tidyverse", "rmarkdown", "reticulate", "JuliaCall"))
```