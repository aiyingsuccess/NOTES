1 cd /data/aiying/Nova/build
make -j 8
./bin/point_process
cd ../Projects/Adaptive_Poisson_Systems/point_process/gnuplot
mv ../../../../build/Ca.txt .
./make_plots.pl
display Ca_values.png


2 cd /data/aiying/Nova/build
make -j 8
./bin/astrocytes_2d -geometry /data/aiying/Astrocytes/star_geometry1.txt
  ls Resolution_864/0/
 ./bin/opengl Resolution_864/

In Nova/build/
./bin/explicit_astrocytes_2d -geometry ../Projects/Adaptive_Poisson_Systems/explicit_astrocytes_2d/data/geometry.txt -glu ../Projects/Adaptive_Poisson_Systems/explicit_astrocytes_2d/data/glu10.txt -threads 4

cp ../Projects/Adaptive_Poisson_Systems/make_video.m .



3#Plugin=libplugin_Embedded_Deformables
Plugin=libplugin_Adaptive_Poisson_Systems

4 git difftool HEAD^
git difftool HEAD^^^^^^^^ "main.cpp"


7control+A/K/ current command
control+L clear all command
reset clear terminal

5 ctags -R *
Ctrl+]   奔赴tag标签 ctrl+w+] 打开多窗口显示tag
Ctrl+T  回到原处
Ctrl+w 切换窗口

6 使用vim 进入cpp文件查看外部库头文件

:set set path=/usr/local/include/   #也可以:set path+=/usr/local/include/ 

然后将光标移动到#include <libmemcached/memcached.h>头文件所在的行；按下gf键便便可以进入到相应头文件

如果要后退可以ctrl+o

7:set path=/usr/include/**or/usr/include** usr/include再下两级目录 

8 tabe .. 上一级目录 tabc 关闭当前tab
s vsp新文件
ctrl o 返回到目录
1+ctrl+g  显示vim文件名

9 grep "keyword" /usr/include/*.h 
查找c++ 库函数中定义“keyword”的头文件

grep -r -i "some string" /home/yourusername
This will find "some string" in /home/yourusername directory. The search will ignore case (-i) and recurse directories (-r)

find / -type f -iname "filename*" if you want to match more files (iname:ignore case in name).
use -type d if you want to search for directories etc. 

using "sudo" before find can void many unnecessary warnings
gr
10 第一种方法，stash：

那怎么stash本地的更新呢？直接执行：

git stash
git pull
git stash pop
接下来diff一下此文件看看自动合并的情况，并作出相应的修改。
git stash：备份当前的工作区，从最近一次提交中读取相关内容，让工作区保持和上一次提交的内容一致。同时，将工作区的内容保存到git栈中。

git stash pop：从git栈中读取最近一次保存的内容，恢复工作区的相关内容。由于可能存在多个stash的内容，所以用栈来管理，pop会从最近一个stash中读取内容并恢复到工作区。

git stash list：显示git栈内的所有备份，可以利用这个列表来决定从那个地方恢复。

git stash clear：情况git栈。
--------------------- 
作者：liuchunming033 
来源：CSDN 
原文：https://blog.csdn.net/liuchunming033/article/details/45368237?utm_source=copy 
版权声明：本文为博主原创文章，转载请附上博文链接！第一种方法，stash：

第二种方法：放弃本地的修改，直接覆盖

git reset --hard
git pull origin develop:develop

11 v--visual mode
   y--copy mode
   p--paste mode

12 ssh-keygen -t rsa -C "youremail@example.com"

git init local file
git remote add origin git@github.com:michaelliao/learngit.git                                    origin is the name of remote respotory

git push -u origin master      master is local repotory 由于远程库是空的，我们第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令

git push origin master     把本地master分支的最新修改推送至GitHub
此后，每次本地提交后，只要有必要，就可以使用命令git push origin master推送最新修改

13 git commit操作的是本地库，git push操作的是远程库

14
Some options
-g - turn on debugging (so GDB gives more friendly output)
-Wall - turns on most warnings
-O or -O2 - turn on optimizations
-o <name> - name of the output file
-c - output an object file (.o)
-I<include path> - specify an include directory
-L<library path> - specify a lib directory
-l<library> - link with library lib<library>.a

15 jupyter notebook

16 set RMANTREE /opt/pixar/RenderManProServer-22.1
  set PATH $RMANTREE/bin:$PATH

17 how to check a lib is installed?
ldconfig -p | grep libjpeg
