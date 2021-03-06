# 项目描述

本项目用于模拟高并发场景下的抢红包业务

学习应对高并发业务几种不同的策略



核心目标：

- 高并发下的数据一致性
- 性能问题

## 技术栈

项目搭建：Spring + Spring MVC + Mybatis (SSM)

## 笔记
- [如何解决数据一致性问题](https://github.com/onemrc/hongbao/blob/master/node/%E6%95%B0%E6%8D%AE%E4%B8%80%E8%87%B4%E6%80%A7.md)
- [Lua脚本注释](https://github.com/onemrc/hongbao/blob/master/node/Lua%E8%84%9A%E6%9C%AC%E6%B3%A8%E9%87%8A.md)

## 部署、测试指南

环境：Tomcat8.0 + MySQL + Redis

### 部署

1. 运行`resources\sql.sql` 新建数据库和表
2. 在config/RootConfig 中，修改好你自己的Redis配置
3. 可以新建多条红包信息一一对应不同的测试情况



### 测试

本项目用了几个不同的jsp页面来测试不同的请求

在每个jsp页面中，使用ajax发送异步请求进行测试

进行测试时，你要做的工作：

1. 修改每个ajax中的 redPacketId （改为数据库中的红包id）, 

2. 在Redis中添加红包信息缓存，示例：

   - ```
     //设置红包id = 10 的红包库存为1000
     hset red_packet_10 stock 1000
     
     //设置红包id = 10 的红包单个金额为 1
     hset red_packet_10 unit_amount 1（
     ```

## 测试结果

测试目的：查看有没有超发的情况和各种不同策略下的性能测试



#### 查看性能方式

```
 select t.stock as stock,min(u.grab_time),max(u.grab_time),max(u.grab_time) - min(u.grab_time) as useTime  from t_user_red_packet as u , t_red_packet as t where u.red_packet_id = #{red_packet_id} and t.id = #{red_packet_id};
```



### 本机测试结果

| 策略                 | 红包个数 | 并发数 | 剩余红包数 | 用时 | 备注        |
| -------------------- | -------- | ------ | ---------- | ---- | ----------- |
| 无                   | 1000     | 1300   | -5         | 27s  |             |
| 悲观锁               | 1000     | 1300   | 0          | 70s  |             |
| 乐观锁               | 1000     | 1300   | 741        | 24s  |             |
| 乐观锁（时间戳重入） | 1000     | 1300   | 686        | 27s  | 1s 内可重入 |
| 乐观锁（计数重入）   | 1000     | 1300   | 719        | 21s  | 可重入10次  |
| 利用Redis            | 1000     | 1300   | 0          | 8s   |             |

