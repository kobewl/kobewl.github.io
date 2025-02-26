---
title: "1 MyBatis 基础知识"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 MyBatis 基础知识

## 1.1 MyBatis 简介

### 1.1.1 什么是 MyBatis

MyBatis 是一个优秀的持久层框架（Persistence Framework），它支持自定义 SQL、存储过程以及高级映射。MyBatis 几乎消除了所有的 JDBC 代码和参数的手动设置以及结果集的检索。

MyBatis 的主要特性：

1. **ORM 框架**：对象关系映射（Object Relational Mapping），将 Java 对象映射到数据库记录
2. **轻量级**：相比 Hibernate，更加轻量级，学习成本低
3. **灵活性**：可以自由编写 SQL，支持动态 SQL，支持存储过程
4. **缓存机制**：支持一级缓存和二级缓存，方便扩展
5. **接口式编程**：通过接口编程，解耦代码，提高可维护性

**MyBatis 整体架构**

```
┌─────────────────────────────────────┐
│           应用层 (Application)        │
├─────────────────────────────────────┤
│     ┌─────────────┐  ┌──────────┐   │
│     │   Mapper    │  │  POJO    │   │
│     └─────────────┘  └──────────┘   │
└─────────────────────────────────────┘
               ↓
┌─────────────────────────────────────┐
│           框架层 (Framework)          │
├─────────────────────────────────────┤
│  ┌────────────┐    ┌────────────┐   │
│  │ SQL Session │←→  │ SQL Builder│   │
│  └────────────┘    └────────────┘   │
│  ┌────────────┐    ┌────────────┐   │
│  │  Executor  │←→  │  Plugins   │   │
│  └────────────┘    └────────────┘   │
└─────────────────────────────────────┘
               ↓
┌─────────────────────────────────────┐
│           数据层 (Persistence)        │
├─────────────────────────────────────┤
│     ┌─────────────┐  ┌──────────┐   │
│     │    JDBC     │  │  DataBase│   │
│     └─────────────┘  └──────────┘   │
└─────────────────────────────────────┘
```

### 1.1.2 MyBatis 的特点

1. **半自动 ORM 映射**

   - 不像 Hibernate 完全可以实现无 SQL 编写
   - 需要程序员自己编写 SQL，但消除了 JDBC 大量重复代码
   - 支持对象与数据库的 ORM 字段关系映射
   - 在对象模型和数据库之间提供更灵活的映射方案

2. **灵活的 SQL 编写**

   - 支持传统 SQL 编写
   - 支持动态 SQL
   - 支持 SQL 复用和提取
   - 支持多种参数传递方式
   - 支持自定义类型处理器

3. **与 JDBC 的比较**

   ```java
   // JDBC 代码示例
   Connection conn = null;
   PreparedStatement stmt = null;
   ResultSet rs = null;
   try {
       conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "user", "password");
       stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
       stmt.setInt(1, 1);
       rs = stmt.executeQuery();
       while(rs.next()) {
           // 手动映射结果集
       }
   } catch (SQLException e) {
       e.printStackTrace();
   } finally {
       // 手动关闭资源
   }

   // MyBatis 代码示例
   User user = sqlSession.selectOne("com.example.UserMapper.getUser", 1);
   ```

### 1.1.3 MyBatis 核心组件

1. **SqlSessionFactoryBuilder**

   - 作用：构建 SqlSessionFactory
   - 生命周期：方法级别，用完即释放

   ```java
   String resource = "mybatis-config.xml";
   InputStream inputStream = Resources.getResourceAsStream(resource);
   SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
   ```

2. **SqlSessionFactory**

   - 作用：创建 SqlSession
   - 生命周期：应用级别，单例模式
   - 线程安全的

   ```java
   SqlSession session = sqlSessionFactory.openSession();
   ```

3. **SqlSession**

   - 作用：执行 SQL，管理事务
   - 生命周期：请求级别
   - 线程不安全，每次请求创建新的

   ```java
   try (SqlSession session = sqlSessionFactory.openSession()) {
       User user = session.selectOne("com.example.UserMapper.getUser", 1);
       session.commit(); // 提交事务
   }
   ```

4. **Mapper 接口**
   - 作用：定义数据库操作方法
   - 生命周期：应用级别
   ```java
   public interface UserMapper {
       User getUser(Integer id);
       List<User> findUsers(String name);
   }
   ```

## 1.2 MyBatis 核心配置

### 1.2.1 全局配置文件（mybatis-config.xml）

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 属性配置 -->
    <properties resource="db.properties"/>

    <!-- 设置 -->
    <settings>
        <!-- 开启驼峰命名转换 -->
        <setting name="mapUnderscoreToCamelCase" value="true"/>
        <!-- 开启二级缓存 -->
        <setting name="cacheEnabled" value="true"/>
    </settings>

    <!-- 类型别名 -->
    <typeAliases>
        <typeAlias type="com.example.entity.User" alias="User"/>
    </typeAliases>

    <!-- 环境配置 -->
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>

    <!-- 映射器 -->
    <mappers>
        <mapper resource="mapper/UserMapper.xml"/>
    </mappers>
</configuration>
```

### 1.2.2 映射配置文件（XxxMapper.xml）

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.mapper.UserMapper">
    <!-- 结果映射 -->
    <resultMap id="userMap" type="User">
        <id property="id" column="id"/>
        <result property="userName" column="user_name"/>
        <result property="age" column="age"/>
    </resultMap>

    <!-- SQL片段 -->
    <sql id="Base_Column_List">
        id, user_name, age
    </sql>

    <!-- 增删改查操作 -->
    <select id="getUser" resultMap="userMap">
        SELECT <include refid="Base_Column_List"/>
        FROM users
        WHERE id = #{id}
    </select>
</mapper>
```

## 1.3 参数处理

### 1.3.1 参数传递方式

1. **单个参数**

   ```java
   User getUser(Integer id);
   // XML中直接使用 #{id} 或 ${id}
   ```

2. **多个参数**

   ```java
   User getUser(@Param("id") Integer id, @Param("name") String name);
   // XML中使用 #{id} 和 #{name}
   ```

3. **POJO 参数**

   ```java
   User insertUser(User user);
   // XML中使用 #{属性名}
   ```

4. **Map 参数**
   ```java
   User getUser(Map<String, Object> params);
   // XML中使用 #{key名}
   ```

### 1.3.2 #{} 和 ${} 的区别

1. **#{}：预编译参数**

   - 防止 SQL 注入
   - 自动进行类型转换
   - 底层使用 PreparedStatement

   ```xml
   SELECT * FROM users WHERE id = #{id}
   <!-- 转换后：SELECT * FROM users WHERE id = ? -->
   ```

2. **${}：字符串拼接**
   - 存在 SQL 注入风险
   - 不做类型转换
   - 用于动态表名、列名等场景
   ```xml
   SELECT * FROM ${tableName} WHERE id = ${id}
   <!-- 转换后：SELECT * FROM users WHERE id = 1 -->
   ```

## 1.4 动态 SQL

### 1.4.1 常用动态 SQL 标签

1. **if 条件判断**

   ```xml
   <select id="findUsers" resultType="User">
       SELECT * FROM users WHERE 1=1
       <if test="userName != null">
           AND user_name LIKE concat('%', #{userName}, '%')
       </if>
   </select>
   ```

2. **choose/when/otherwise 选择**

   ```xml
   <select id="findUsers" resultType="User">
       SELECT * FROM users WHERE 1=1
       <choose>
           <when test="userName != null">
               AND user_name = #{userName}
           </when>
           <when test="age != null">
               AND age = #{age}
           </when>
           <otherwise>
               AND status = 'ACTIVE'
           </otherwise>
       </choose>
   </select>
   ```

3. **trim/where/set 条件包装**

   ```xml
   <select id="findUsers" resultType="User">
       SELECT * FROM users
       <where>
           <if test="userName != null">
               AND user_name = #{userName}
           </if>
       </where>
   </select>

   <update id="updateUser">
       UPDATE users
       <set>
           <if test="userName != null">user_name = #{userName},</if>
           <if test="age != null">age = #{age},</if>
       </set>
       WHERE id = #{id}
   </update>
   ```

4. **foreach 循环**
   ```xml
   <select id="findUsersByIds" resultType="User">
       SELECT * FROM users WHERE id IN
       <foreach collection="list" item="id" open="(" separator="," close=")">
           #{id}
       </foreach>
   </select>
   ```

## 1.5 结果映射

### 1.5.1 基本结果映射

```xml
<resultMap id="userMap" type="User">
    <id property="id" column="id"/>
    <result property="userName" column="user_name"/>
    <result property="age" column="age"/>
</resultMap>
```

### 1.5.2 关联查询映射

```xml
<resultMap id="userWithOrdersMap" type="User">
    <id property="id" column="id"/>
    <result property="userName" column="user_name"/>
    <!-- 一对多关联 -->
    <collection property="orders" ofType="Order">
        <id property="orderId" column="order_id"/>
        <result property="orderNo" column="order_no"/>
    </collection>
</resultMap>
```

### 1.5.3 自动映射

1. **开启驼峰命名转换**

   ```xml
   <setting name="mapUnderscoreToCamelCase" value="true"/>
   ```

2. **自动映射级别**
   ```xml
   <setting name="autoMappingBehavior" value="PARTIAL"/>
   <!-- NONE：禁用自动映射 -->
   <!-- PARTIAL：只对没有嵌套结果映射的字段自动映射 -->
   <!-- FULL：对所有字段自动映射 -->
   ```

## 1.6 MyBatis 缓存机制

### 1.6.1 一级缓存

1. **定义与特点**

   - SqlSession 级别的缓存
   - 默认开启，无法关闭
   - 生命周期与 SqlSession 相同
   - 是 HashMap 本地缓存

2. **缓存失效的情况**

   ```java
   // 1. 不同的 SqlSession
   SqlSession session1 = sqlSessionFactory.openSession();
   User user1 = session1.selectOne("getUser", 1); // 查询数据库

   SqlSession session2 = sqlSessionFactory.openSession();
   User user2 = session2.selectOne("getUser", 1); // 查询数据库

   // 2. 同一个 SqlSession 但是查询条件不同
   User user3 = session1.selectOne("getUser", 2); // 查询数据库

   // 3. 同一个 SqlSession 两次查询期间执行了任何一次增删改操作
   session1.update("updateUser", user1); // 更新操作
   User user4 = session1.selectOne("getUser", 1); // 查询数据库

   // 4. 同一个 SqlSession 两次查询期间手动清空了缓存
   session1.clearCache(); // 清空缓存
   User user5 = session1.selectOne("getUser", 1); // 查询数据库
   ```

### 1.6.2 二级缓存

1. **定义与特点**

   - Mapper 级别的缓存
   - 需要手动开启
   - 多个 SqlSession 共享
   - 可自定义缓存实现

2. **开启二级缓存**

   ```xml
   <!-- mybatis-config.xml 中开启二级缓存 -->
   <settings>
       <setting name="cacheEnabled" value="true"/>
   </settings>

   <!-- Mapper.xml 中配置缓存 -->
   <cache
       eviction="LRU"
       flushInterval="60000"
       size="512"
       readOnly="true"/>
   ```

3. **缓存策略**

   - LRU（默认）：最近最少使用
   - FIFO：先进先出
   - SOFT：软引用
   - WEAK：弱引用

4. **使用示例**

   ```java
   // 需要实体类实现序列化接口
   public class User implements Serializable {
       private static final long serialVersionUID = 1L;
       // ... 属性和方法
   }

   // 使用二级缓存
   SqlSession session1 = sqlSessionFactory.openSession();
   SqlSession session2 = sqlSessionFactory.openSession();

   User user1 = session1.selectOne("getUser", 1); // 查询数据库
   session1.commit(); // 必须提交事务，二级缓存才会生效

   User user2 = session2.selectOne("getUser", 1); // 从二级缓存获取
   ```

5. **注意事项**
   - 实体类必须实现 Serializable 接口
   - 查询操作需要提交事务才会放入二级缓存
   - 增删改会清空二级缓存
   - 建议只对经常查询且不经常修改的数据使用二级缓存

### 1.6.3 自定义缓存

1. **实现 Cache 接口**

   ```java
   public class CustomCache implements Cache {
       private String id;
       private Map<Object, Object> cache = new HashMap<>();

       public CustomCache(String id) {
           this.id = id;
       }

       @Override
       public String getId() {
           return this.id;
       }

       @Override
       public void putObject(Object key, Object value) {
           cache.put(key, value);
       }

       @Override
       public Object getObject(Object key) {
           return cache.get(key);
       }

       // ... 其他必须实现的方法
   }
   ```

2. **配置自定义缓存**
   ```xml
   <cache type="com.example.cache.CustomCache"/>
   ```

**缓存架构图**

```
┌──────────────────────────────────────────┐
│              应用程序                     │
└──────────────────────────────────────────┘
                   ↓
┌─────────────────────┐  ┌─────────────────┐
│    SqlSession A     │  │   SqlSession B  │
│  ┌───────────────┐  │  │ ┌─────────────┐ │
│  │   一级缓存    │  │  │ │  一级缓存   │ │
│  └───────────────┘  │  │ └─────────────┘ │
└─────────────────────┘  └─────────────────┘
            ↓                     ↓
┌──────────────────────────────────────────┐
│              二级缓存（共享）             │
│    ┌────────────┐    ┌────────────┐      │
│    │  Mapper1   │    │  Mapper2   │      │
│    └────────────┘    └────────────┘      │
└──────────────────────────────────────────┘
                   ↓
┌──────────────────────────────────────────┐
│                数据库                     │
└──────────────────────────────────────────┘
```

## 9. MyBatis 缓存深入

### 9.1 一级缓存工作机制

1. **工作原理**

   ```java
   // 一级缓存的底层数据结构
   private Map<Object, Object> cache = new HashMap<>();

   // 缓存Key的组成部分
   private Object createCacheKey(MappedStatement ms, Object parameterObject, RowBounds rowBounds, BoundSql boundSql) {
       CacheKey cacheKey = new CacheKey();
       cacheKey.update(ms.getId()); // Mapper的namespace + SQL的id
       cacheKey.update(rowBounds.getOffset()); // 分页参数
       cacheKey.update(rowBounds.getLimit()); // 分页参数
       cacheKey.update(boundSql.getSql()); // SQL语句
       cacheKey.update(parameterObject); // 参数值
       return cacheKey;
   }
   ```

2. **详细的失效场景**

   ```java
   // 1. 不同的 SqlSession
   SqlSession session1 = sqlSessionFactory.openSession();
   User user1 = session1.selectOne("getUser", 1);  // 查询数据库
   session1.close();

   SqlSession session2 = sqlSessionFactory.openSession();
   User user2 = session2.selectOne("getUser", 1);  // 查询数据库，因为是新的SqlSession

   // 2. 相同 SqlSession，但是查询条件不同
   User user3 = session1.selectOne("getUser", 2);  // 查询数据库，因为参数不同

   // 3. 相同 SqlSession，但是在两次查询期间执行了任何增删改操作
   session1.update("updateUser", user1);  // 更新操作
   User user4 = session1.selectOne("getUser", 1);  // 查询数据库，因为执行了更新

   // 4. 相同 SqlSession，但手动清空了缓存
   session1.clearCache();  // 清空缓存
   User user5 = session1.selectOne("getUser", 1);  // 查询数据库，因为缓存被清空

   // 5. 相同 SqlSession，但是使用了不同的查询方式
   List<User> users1 = session1.selectList("getUsers");  // 查询数据库
   User user6 = session1.selectOne("getUsers");  // 查询数据库，因为使用了不同的查询方法
   ```

### 9.2 二级缓存注意事项

1. **事务相关**

   ```java
   // 事务提交前，二级缓存不会生效
   SqlSession session1 = sqlSessionFactory.openSession();
   User user1 = session1.selectOne("getUser", 1);  // 查询数据库
   // 此时数据还在一级缓存中，还未放入二级缓存

   SqlSession session2 = sqlSessionFactory.openSession();
   User user2 = session2.selectOne("getUser", 1);  // 查询数据库

   session1.commit();  // 事务提交，数据才会放入二级缓存
   User user3 = session2.selectOne("getUser", 1);  // 从二级缓存获取
   ```

2. **更新操作的影响**

   ```xml
   <!-- 在Mapper中配置二级缓存 -->
   <cache
       eviction="LRU"
       flushInterval="60000"  <!-- 缓存刷新间隔 -->
       size="512"            <!-- 最多缓存512个引用 -->
       readOnly="true"/>     <!-- true: 返回缓存对象的拷贝; false: 返回实际对象 -->
   ```

3. **分布式环境的注意事项**
   - 多个应用共享数据库时，需要考虑缓存一致性问题
   - 建议使用集中式缓存（如 Redis）替代 MyBatis 二级缓存
   ```xml
   <!-- 使用自定义缓存实现，如Redis -->
   <cache type="com.example.cache.RedisCache"/>
   ```

## 10. MyBatis 执行流程

### 10.1 SQL 执行流程

**MyBatis SQL 执行流程图**

```
┌──────────────────────────────────────┐
│           1. 读取配置文件             │
│ ┌─────────┐         ┌─────────────┐  │
│ │ 配置文件 │   →     │Configuration│  │
│ └─────────┘         └─────────────┘  │
└──────────────────────────────────────┘
                ↓
┌──────────────────────────────────────┐
│           2. 创建会话                 │
│ ┌─────────┐         ┌─────────────┐  │
│ │ 构建工厂 │   →     │ SqlSession  │  │
│ └─────────┘         └─────────────┘  │
└──────────────────────────────────────┘
                ↓
┌──────────────────────────────────────┐
│           3. 执行SQL语句              │
│     ┌───────────────────────┐        │
│     │ 查询一级缓存（命中返回）│        │
│     └───────────────────────┘        │
│                ↓ (未命中)            │
│     ┌───────────────────────┐        │
│     │ 查询二级缓存（命中返回）│        │
│     └───────────────────────┘        │
│                ↓ (未命中)            │
│     ┌───────────────────────┐        │
│     │    执行SQL查询数据库   │        │
│     └───────────────────────┘        │
└──────────────────────────────────────┘
                ↓
┌──────────────────────────────────────┐
│           4. 处理结果                 │
│ ┌─────────┐         ┌─────────────┐  │
│ │结果映射  │   →     │  Java对象   │  │
│ └─────────┘         └─────────────┘  │
└──────────────────────────────────────┘
                ↓
┌──────────────────────────────────────┐
│           5. 更新缓存                 │
│ ┌─────────┐         ┌─────────────┐  │
│ │写入缓存  │   →     │返回最终结果 │  │
│ └─────────┘         └─────────────┘  │
└──────────────────────────────────────┘
```

主要执行步骤说明：

1. **读取配置文件**

   - 解析 mybatis-config.xml
   - 创建 Configuration 对象

2. **创建会话**

   - 构建 SqlSessionFactory
   - 创建 SqlSession 实例

3. **执行 SQL 语句**

   - 检查一级缓存
   - 检查二级缓存
   - 访问数据库

4. **处理结果**

   - 将结果集映射为 Java 对象
   - 处理关联关系

5. **更新缓存**
   - 更新一级/二级缓存
   - 返回最终结果

### 10.2 缓存失效场景详解

#### 1. 一级缓存失效场景

1. **会话相关**

   ```java
   // 1.1 不同的 SqlSession 实例
   SqlSession session1 = sqlSessionFactory.openSession();
   User user1 = session1.selectOne("getUser", 1);  // 查询数据库

   SqlSession session2 = sqlSessionFactory.openSession();
   User user2 = session2.selectOne("getUser", 1);  // 查询数据库，不共享缓存

   // 1.2 同一个 SqlSession 关闭后重新开启
   session1.close();
   session1 = sqlSessionFactory.openSession();
   User user3 = session1.selectOne("getUser", 1);  // 查询数据库
   ```

2. **操作相关**

   ```java
   // 2.1 同一个 SqlSession 执行任何增删改操作
   SqlSession session = sqlSessionFactory.openSession();
   User user1 = session.selectOne("getUser", 1);    // 查询数据库
   session.update("updateUser", user1);             // 执行更新
   User user2 = session.selectOne("getUser", 1);    // 再次查询数据库

   // 2.2 手动清空缓存
   session.clearCache();
   User user3 = session.selectOne("getUser", 1);    // 查询数据库
   ```

3. **查询条件相关**

   ```java
   // 3.1 查询条件不同
   User user1 = session.selectOne("getUser", 1);    // 查询数据库
   User user2 = session.selectOne("getUser", 2);    // 查询数据库

   // 3.2 查询方法不同
   User user3 = session.selectOne("getUser", 1);    // 查询数据库
   List<User> users = session.selectList("getUser", 1); // 查询数据库
   ```

4. **语句相关**

   ```java
   // 4.1 使用不同的 SQL 语句
   User user1 = session.selectOne("getUser", 1);    // 查询数据库
   User user2 = session.selectOne("getUserByName", "张三"); // 查询数据库

   // 4.2 使用动态 SQL 导致的语句不同
   Map<String, Object> params1 = new HashMap<>();
   params1.put("id", 1);
   User user3 = session.selectOne("findUser", params1);  // 查询数据库

   Map<String, Object> params2 = new HashMap<>();
   params2.put("id", 1);
   params2.put("name", "张三");
   User user4 = session.selectOne("findUser", params2);  // 查询数据库
   ```

#### 2. 二级缓存失效场景

1. **事务相关**

   ```java
   // 1.1 事务未提交
   SqlSession session1 = sqlSessionFactory.openSession();
   User user1 = session1.selectOne("getUser", 1);    // 查询数据库
   // 此时数据还在一级缓存中，未写入二级缓存

   SqlSession session2 = sqlSessionFactory.openSession();
   User user2 = session2.selectOne("getUser", 1);    // 查询数据库

   // 1.2 事务回滚
   session1.rollback();  // 回滚事务，缓存失效
   ```

2. **更新操作**

   ```java
   // 2.1 任何更新操作都会使二级缓存失效
   SqlSession session1 = sqlSessionFactory.openSession();
   User user1 = session1.selectOne("getUser", 1);
   session1.commit();  // 写入二级缓存

   SqlSession session2 = sqlSessionFactory.openSession();
   session2.update("updateUser", user1);  // 更新操作
   session2.commit();  // 清空二级缓存

   SqlSession session3 = sqlSessionFactory.openSession();
   User user2 = session3.selectOne("getUser", 1);  // 查询数据库
   ```

3. **配置相关**

   ```java
   // 3.1 未开启二级缓存
   <setting name="cacheEnabled" value="false"/>

   // 3.2 Mapper 中未配置缓存
   <mapper namespace="com.example.UserMapper">
       <!-- 没有配置 <cache/> 标签 -->
   </mapper>

   // 3.3 语句配置不使用缓存
   <select id="getUser" resultType="User" useCache="false">
       SELECT * FROM users WHERE id = #{id}
   </select>
   ```

4. **分布式环境**

   ```java
   // 4.1 多个应用实例导致的缓存不一致
   // 应用A更新数据
   SqlSession sessionA = sqlSessionFactoryA.openSession();
   sessionA.update("updateUser", user);
   sessionA.commit();

   // 应用B读取到旧数据（因为缓存未同步）
   SqlSession sessionB = sqlSessionFactoryB.openSession();
   User oldUser = sessionB.selectOne("getUser", 1);
   ```

5. **缓存刷新**
   ```xml
   <!-- 5.1 配置了定时刷新 -->
   <cache
       eviction="LRU"
       flushInterval="60000"  <!-- 每60秒刷新一次 -->
       size="512"
       readOnly="true"/>
   ```

这些场景涵盖了 MyBatis 缓存失效的主要情况，理解这些场景对于正确使用缓存和排查缓存相关问题非常重要。在实际应用中，需要根据具体业务场景来决定是否使用缓存以及如何配置缓存策略。

## 11. 常见问题与解决方案

### 11.1 N+1 查询问题

1. **问题描述**

   ```java
   // 查询所有用户及其订单
   List<User> users = userMapper.getAllUsers();  // 1次查询
   for (User user : users) {
       List<Order> orders = orderMapper.getOrdersByUserId(user.getId());  // N次查询
   }
   ```

2. **解决方案**

   **N+1 问题与解决方案**

   ```
   ┌─────────────── N+1 问题 ───────────────┐
   │                                        │
   │  ┌──────────┐   ┌─────┐   ┌──────────┐│
   │  │查询用户列表│ → │循环 │ → │查询每个订单││
   │  └──────────┘   └─────┘   └──────────┘│
   │        1次         N次        N次      │
   └────────────────────────────────────────┘
                   ↓
   ┌─────────────── 优化方案 ───────────────┐
   │ ┌────────────────────────────────────┐ │
   │ │         方案1：关联查询             │ │
   │ │     SELECT u.*, o.*                │ │
   │ │     FROM user u                    │ │
   │ │     LEFT JOIN order o ON u.id=o.uid│ │
   │ └────────────────────────────────────┘ │
   │                  或                     │
   │ ┌────────────────────────────────────┐ │
   │ │         方案2：延迟加载             │ │
   │ │     <collection                    │ │
   │ │        property="orders"           │ │
   │ │        select="getOrders"          │ │
   │ │        fetchType="lazy"/>          │ │
   │ └────────────────────────────────────┘ │
   └────────────────────────────────────────┘
   ```

### 11.2 动态 SQL 优化

1. **避免复杂条件**

   ```xml
   <!-- 不推荐 -->
   <if test="name != null and name.length > 0 and name.length < 50">

   <!-- 推荐 -->
   <if test="@com.example.util.StringUtil@isValid(name)">
   ```

2. **使用 include 复用 SQL 片段**

   ```xml
   <sql id="userColumns">
       id, name, age, email
   </sql>

   <select id="getUser" resultType="User">
       SELECT <include refid="userColumns"/>
       FROM users
       WHERE id = #{id}
   </select>
   ```

### 11.3 性能监控

1. **SQL 性能监控**

   ```java
   // 使用拦截器记录SQL执行时间
   @Intercepts({
       @Signature(type = StatementHandler.class, method = "query", args = {Statement.class, ResultHandler.class})
   })
   public class SqlCostInterceptor implements Interceptor {
       @Override
       public Object intercept(Invocation invocation) throws Throwable {
           long startTime = System.currentTimeMillis();
           try {
               return invocation.proceed();
           } finally {
               long endTime = System.currentTimeMillis();
               long sqlCost = endTime - startTime;
               log.info("SQL执行时间：{}ms", sqlCost);
           }
       }
   }
   ```

2. **慢 SQL 日志**
   ```xml
   <!-- logback-spring.xml 配置 -->
   <logger name="com.example.mapper" level="DEBUG"/>
   ```

## 12. 图解 MyBatis

### 12.1 MyBatis 架构图

```
+------------------------+
|       应用程序          |
+------------------------+
           ↓
+------------------------+
|    SqlSessionFactory   |
+------------------------+
           ↓
+------------------------+
|      SqlSession       |
+------------------------+
           ↓
+------------------------+
|    Executor(执行器)    |
+------------------------+
           ↓
+------------------------+
|   StatementHandler    |
|   ParameterHandler    |
|   ResultSetHandler    |
+------------------------+
           ↓
+------------------------+
|        JDBC           |
+------------------------+
           ↓
+------------------------+
|       Database        |
+------------------------+
```

### 12.2 一级缓存和二级缓存示意图

```
+------------------+     +------------------+
|   SqlSession1    |     |   SqlSession2    |
|  +------------+  |     |  +------------+  |
|  | 一级缓存    |  |     |  | 一级缓存    |  |
|  +------------+  |     |  +------------+  |
+------------------+     +------------------+
          ↓                      ↓
+------------------------------------------+
|              二级缓存（Mapper级别）         |
+------------------------------------------+
                   ↓
+------------------------------------------+
|                 数据库                     |
+------------------------------------------+
```

### 12.3 执行流程图

```
开始
 ↓
配置文件解析
 ↓
创建 SqlSessionFactory
 ↓
创建 SqlSession
 ↓
获取 Mapper 代理对象
 ↓
调用 Mapper 方法
 ↓
查询一级缓存 → 命中 → 返回结果
 ↓ (未命中)
查询二级缓存 → 命中 → 返回结果
 ↓ (未命中)
查询数据库
 ↓
结果映射处理
 ↓
更新缓存
 ↓
返回结果
```

### 12.4 动态 SQL 工作原理

```
+-------------------+
| 原始 SQL 模板     |
+-------------------+
         ↓
+-------------------+
| 动态标签解析      |
| - if             |
| - choose/when    |
| - where/set      |
| - foreach        |
+-------------------+
         ↓
+-------------------+
| 参数替换         |
| #{} → ?         |
| ${} → 直接替换   |
+-------------------+
         ↓
+-------------------+
| 最终 SQL         |
+-------------------+
```

### 12.5 结果映射过程

```
数据库结果集
     ↓
+------------------------+
| ResultSetHandler       |
|------------------------|
| 1. 创建目标对象        |
| 2. 基本类型映射        |
| 3. 复杂类型映射        |
| 4. 关联对象映射        |
+------------------------+
     ↓
Java 对象
```

### 12.6 插件工作机制

```
请求 → 目标方法
     ↓
+------------------------+
| 插件链                 |
|------------------------|
| Plugin1               |
|   ↓                   |
| Plugin2               |
|   ↓                   |
| Plugin3               |
+------------------------+
     ↓
目标方法执行
     ↓
结果返回
```

### 12.7 缓存更新策略

```
查询请求
   ↓
+------------------+
| 一级缓存检查      |
+------------------+
   ↓ (未命中)
+------------------+
| 二级缓存检查      |
+------------------+
   ↓ (未命中)
+------------------+
| 查询数据库        |
+------------------+
   ↓
+------------------+
| 更新一级缓存      |
+------------------+
   ↓
+------------------+
| 事务提交         |
+------------------+
   ↓
+------------------+
| 更新二级缓存      |
+------------------+
```

### 12.8 N+1 问题图解

```
不良实践：
查询用户列表 (1次)
   ↓
循环查询每个用户的订单 (N次)
   ↓
性能问题

优化方案：
+------------------------+
| 关联查询               |
|------------------------|
| LEFT JOIN             |
| 一次性获取所有数据     |
+------------------------+
        或
+------------------------+
| 延迟加载              |
|------------------------|
| 按需加载关联数据       |
| 避免无谓的查询         |
+------------------------+
```

### 12.9 性能优化关键点

```
+--------------------------------+
|           性能优化              |
|--------------------------------|
| ├── SQL优化                    |
| |   ├── 合理索引              |
| |   ├── 批量操作              |
| |   └── 分页查询              |
|--------------------------------|
| ├── 缓存优化                   |
| |   ├── 合理使用一级缓存       |
| |   ├── 选择性使用二级缓存     |
| |   └── 集中式缓存替代         |
|--------------------------------|
| ├── 连接池优化                 |
| |   ├── 合理连接数            |
| |   └── 及时释放              |
|--------------------------------|
| └── 代码优化                   |
|     ├── 避免N+1查询           |
|     └── 合理使用动态SQL       |
+--------------------------------+
```

这些图表可以帮助你更好地理解：

1. MyBatis 的整体架构
2. 缓存机制的工作原理
3. SQL 执行的完整流程
4. 动态 SQL 的处理过程
5. 结果映射的处理流程
6. 插件机制的工作原理
7. 缓存的更新策略
8. N+1 问题的产生和解决方案
9. 性能优化的关键点

这些图表都是使用 ASCII 字符绘制的，可以直接在 Markdown 中显示，便于理解和记忆。需要我对某个图表做更详细的解释吗？

**性能优化全景图**

```
┌─────────────── MyBatis 性能优化 ─────────────┐
│                                              │
│  ┌─────────────┐        ┌─────────────┐     │
│  │   SQL优化    │        │   缓存优化   │     │
│  │ ┌─────────┐ │        │ ┌─────────┐ │     │
│  │ │索引优化  │ │        │ │一级缓存 │ │     │
│  │ │批量操作  │ │        │ │二级缓存 │ │     │
│  │ │分页查询  │ │        │ │自定义   │ │     │
│  └─────────────┘        └─────────────┘     │
│                                              │
│  ┌─────────────┐        ┌─────────────┐     │
│  │   代码优化   │        │  连接池优化  │     │
│  │ ┌─────────┐ │        │ ┌─────────┐ │     │
│  │ │动态SQL  │ │        │ │连接数   │ │     │
│  │ │N+1问题  │ │        │ │超时配置 │ │     │
│  │ │结果映射  │ │        │ │释放机制 │ │     │
│  └─────────────┘        └─────────────┘     │
└──────────────────────────────────────────────┘
```

这些新设计的图表更加美观和清晰，使用了更多的 ASCII 艺术元素来展示层次结构和关系。每个图表都放在了最相关的内容部分，可以帮助读者更好地理解相应的概念。

需要我对某个图表做进一步的优化或解释吗？

