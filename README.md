```
{
    "rate_button_enable": true,
    "rate_max_show": 5,
    "rate_split_count": 0,
    "rate_app_store_url": "https://www.baidu.com",
    "rate_app_store_timeInterval": 10,
}
```
参数配置说明:

1. 是否开启评论<br/>
    `rate_button_enable` 可以设置为 `true`, `false`
2. 最多显示次数<br/>
    `rate_max_show` 必须设置为整数类型
3. 间隔数<br/>
    `rate_split_count` 必须设置为整数类型, 设置为0代表没有间隔
4. 评论地址<br/>
    `rate_app_store_url` 可以设置为 App Store 的链接, 网页(必须以`https://`开头)等都可以
5. 点击评论按钮后多久可以判断是评论成功<br/>
    `rate_app_store_timeInterval` 单位是秒
6. 标题
`rate_alert_title_key`
7. 内容
`rate_content_title_key`
7. 确定按钮
`rate_confirm_title_key`

