# arch-config
archlinux后续的一些配置（折腾）

### 图形界面
果然我还是王道征途i3gaps+polybar吧

1. 显卡驱动
```
# lspci | grep VGA    # 确定显卡型号
# pacman -S <驱动包>
#
# # 官方仓库提供的驱动包：
# # +----------------------+--------------------+--------------+
# # |                      |        开源        |     私有     |
# # +----------------------+--------------------+--------------+
# # |         通用         |   xf86-video-vesa  |              |
# # +----------------------+--------------------+--------------+
# # |         Intel        |  xf86-video-intel  |              |
# # +--------+-------------+--------------------+--------------+
# # |        | GeForce 9+  |                    |    nvidia    |
# # +        +-------------+                    +--------------+
# # | nVidia | GeForce 8/9 | xf86-video-nouveau | nvidia-340xx |
# # +        +-------------+                    +--------------+
# # |        | GeForce 6/7 |                    | nvidia-304xx |
# # +--------+-------------+--------------------+--------------+
# # |        AMD/ATI       |   xf86-video-ati   |              |
# # +----------------------+--------------------+--------------+
```

2. 然后安装xorg
```
$ pacman -S xorg xorg-xinit
#别人只下了 xorg-server 和xorg-xinit
#但我试了一下 startx进去后文字显示不出来
#那就不管了 直接安装xorg吧
```
3. 安装i3-gaps
```
$ pacman  -S i3-gaps
```
4. 创建用户

配置之前要先创建用户
因为配置文件都是要放在家目录下的
```
$ useradd -m  -G wheel -s /bin/bash username
$ visudo  #提升权限
```
然后把`%wheel ALL=(ALL) NOPASSWD: ALL`这一行的注释删除
这样sudo就不用每次都输密码了

5. 切换用户，并拷贝xinitrc文件到用户目录
```
$ su username
$ sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc
```
6. 在.xinitrc添加如下内容
```
exec i3 -V >> ~/.config/i3/log/i3log-$(date +'%F-%k-%M-%S') 2>&1
#没有的话就创建
```

7. startx进入图形界面
```
$ startx
```
测试一下

8. 安装polybar 
```
$yaourt -S polybar-git
```
yaourt的安装参照[这里](https://archlinux.fr/yaourt-en)

9. 下载polybar所需要的字体

注意要先下载字体不然无法显示图标
```
$ yaourt -S siji-git
```
10. 安装一些插件

一般就 termite feh compton rofi
```
$ pacman -S termite feh compton rofi
```
11. 从我的仓库中拷贝我的配置文件到home目录对应的配置目录
```
git clone git@github.com:j3N0/arch-config.git
```
然后稍加修改就可以startx了

图形界面也差不多就这些了吧

配置很朴素， 都是根据example的修改的 

但依旧配的很累 要深究的话还是以后在去研究吧（不想再踩坑了


### fcitx
fcitx是真的坑
1. 下载fcitx
```
$ pacman -S fcitx
```
2. 下载fcitx-sogoupinyin
```
$ yaourt -S qtwebkit-bin        #先下这个编译好的依赖，不然源码编译太费时了
$ yaourt -S fcitx-sogoupinyin
```
将下面内容加入`.xinitrc`
```
 export GTK_IM_MODULE=fcitx
 export QT_IM_MODULE=fcitx
 export XMODIFIERS=@im=fcitx
 ```

 以及在shell的环境中加入
```
export LANG=zh_CN.UTF-8
```
bash: `.bashrc`

zsh: `.zshrc`

一般到这也就结束了， 但是发现启动fcitx后切搜狗输入法一直异常
删除配置文件也没有用， 后面发现原来sogou-qimpanel 的某个库没有。

真坑

3. 原来还要安装一个东西
```
$ pacman -S fcitx-qt4
```
总算是可以了

一路下来，我都不知道为啥， 我的确是安装了所需要的依赖，yaourt也正常，
但为什么还是要下其他的包才能正常运行sogou，也不知道是bug还是什么，反正查找解决办法的时候真的心累( ´_ゝ`)

我估计是我安装qtwebkit-bin的缘故吧。

还有个奇怪的事情， 虽然后续能正常运行了， 但fcitx的托盘不能显示了， 打字的时候输入框也有点怪异， 但是我装vscode的时候托盘又出来了。(黑人问号


### 疑难杂症

1. grub

也不知道什么原因， 总是会在启动的时候报usb错误，
而且还是一直不停在屏幕上滚动报错

反正具体原因我也不太清楚， 好像是电脑型号太旧的缘故吧

在`/etc/default/grub` 中找到`GRUB_CMDLINE_LINUX_DEFAULT`这一行， 修改为：
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.old_scheme_first=Y"
```
然后生成新的配置文件
```
$ grub-mkconfig -o /boot/grub/grub.cfg
```

就可以抑制报错， 我印象中配置后就只报过一次错。

总之， 这样就算解决了（虽然不知道发生了什么

2. shadowsocks

shadowsocks要下AUR里的那个， 官方的那个有些加密方式不支持
```
$ yaourt -S shadowsocks-git
```

