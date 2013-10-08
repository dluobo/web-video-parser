API说明：

单个视频解析部分：

优酷视频解析

```ruby
vp = VideoParser::Youku.new('http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html')
vp.uid # 返回视频的唯一 id，不同视频网站的 uid 可能名称不同
vp.cover_url # 返回视频封面图片地址
vp.title # 返回视频标题
vp.files # 返回视频真实文件地址和相关参数数组。
```

土豆视频解析

```ruby
vp = VideoParser::Tudou.new('http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html')
vp.uid # 返回视频的唯一 id，不同视频网站的 uid 可能名称不同
vp.cover_url # 返回视频封面图片地址
vp.title # 返回视频标题
vp.files # 返回视频真实文件地址和相关参数数组。
```

新浪视频解析

```ruby
vp = VideoParser::Sina.new('http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html')
vp.uid # 返回视频的唯一 id，不同视频网站的 uid 可能名称不同
vp.cover_url # 返回视频封面图片地址
vp.title # 返回视频标题
vp.files # 返回视频真实文件地址和相关参数数组。
```

参考 minpin/eshare 下 web_video 目录中的 tudou_video.rb, sina_video.rb, youku_video.rb 进行移植
