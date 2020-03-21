# cdnbye_ijk_example

cdnbye的ijk版播放器example。由于ijk的安装远没有官方的videoplayer快，所以单独作为一个仓库，而不是作为pub库中随附的example。

# 功能

- [X] 增加并管理任意链接列表
- [X] 使用flutter_ijk播放器播放自定义的视频链接
- [X] 在播放视频时，可以实时查看cdnbye的p2p效果

# TODO

- [ ] 设置token，目前固定为free
- [ ] 播放本地文件
- [ ] 用户设置：landscape方向
- [ ] 用户设置：是否自动播放
- [ ] 用户设置：是否硬解码


# ijkplayer

[![pub package](https://img.shields.io/pub/v/flutter_ijkplayer.svg)](https://pub.dartlang.org/packages/flutter_ijkplayer)

ijkplayer,通过纹理的方式接入 [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer)

## ijk原生部分说明

### 自定义编译和原生部分源码

自定义编译的主要目的是修改支持的格式, 因为默认包含了一些编解码器,解复用,协议等等, 这些格式可能你的项目用不到, 这时候可以修改 ffmpeg 的自定义编译选项, 以便于可以缩小库文件的体积, 以达到给 app 瘦身的目的

[当前的编译规则文件](https://gitee.com/kikt/ijkplayer_thrid_party/blob/master/config/module.sh),修改编译选项,这个参考 [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer) 或 [ffmpeg](http://ffmpeg.org/),ffmpeg 的相关信息也可以通过搜索引擎获取

自定义编译选项的完整过程请看[文档](https://github.com/CaiJingLong/flutter_ijkplayer/blob/master/compile-cn.md), 否则不保证编译出来的代码不报错, 具体的更改方案也请查看编译文档, 本篇不再提及

### iOS

因为 iOS 部分代码的库文件比较大,为了方便管理版本, 所以创建了一个 pod 依赖托管 iOS 的 ijkplayer 库
pod 库托管在 github 仓库内 ,因为网速原因,源码托管在 [azure](https://dev.azure.com/cjlspy/_git/flutter_ijkplayer_pod)

因为 framework 文件的大小超过了 100M,所以采用了压缩的方式储存
没有采用通用的 tar.gz 或 zip,而是使用 tar.xz 的方式压缩,这个压缩格式压缩率高,但是压缩和解压缩的的速度慢,综合考虑使用高压缩率的方式来快速获取源文件并解压缩  
如果有朋友愿意提供 cdn 加速,可以联系我 😁

iOS 的原始代码来自于 https://github.com/jadennn/flutter_ijk 中提供的 iOS 代码, 但在这基础上有了修改, 不能直接使用这个仓库的源码, 修改后的项目源码托管在[gitee](https://gitee.com/kikt/ijkplayer_thrid_party)

#### 运行慢的问题

最新的 0.3.3 版本的 pod 库(版本号 0.1.0)库文件托管在 [azure](https://dev.azure.com/cjlspy/_git/flutter_ijkplayer_pod), 在美西下载速度可以达到 4~5M/s 只需要 20 秒左右就可以下载完, 10 多秒解压缩, 国内则会慢很多, 下载速度 1.5M/s 左右, 所以请耐心等待

0.3.2 以前的 pod 源码托管在 github, 国外下载速度能达到 5~6M/s, 国内速度则不足 100k, 所以可能需要 20 分钟, 建议没有用过这个库的人使用最新版本(0.3.3+)或使用代理
