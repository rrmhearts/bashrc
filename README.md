# bashrc


## Requirements

There are Android dependencies that should be removed if you're not doing AOSP development.

The following is needed for the new terminal and searching functionality:
```
sudo apt install fortune verse silversearcher-ag screenfetch libgnome2-bin
```
In addition, the tool timg is needed for the initial splash image. Binary is under usr/ for x86_64. However, here is the instructions to install on your own
```
git clone https://github.com/hzeller/timg.git
cd timg/src
sudo apt-get install libwebp-dev libgraphicsmagick++1-dev    # required libs.
make
sudo make install
```

Put the included image under `~/Pictures` where you would like.
