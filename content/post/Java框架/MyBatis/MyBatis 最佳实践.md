---
title: "MyBatis 最佳实践"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# MyBatis 最佳实践

MyBatis 是一款流行的 ORM 框架，在实际项目中需要合理使用才能充分发挥其优势。本文将介绍使用 MyBatis 的最佳实践，包括性能优化、代码组织、安全性等方面，帮助开发者更高效地使用 MyBatis。

## 目录

- [配置与设计](#配置与设计)
- [SQL 编写与优化](#sql-编写与优化)
- [性能优化](#性能优化)
- [安全性](#安全性)
- [代码组织](#代码组织)
- [测试策略](#测试策略)
- [与其他框架集成](#与其他框架集成)
- [常见陷阱与解决方案](#常见陷阱与解决方案)

## 配置与设计

### 1. 配置文件规范

**MyBatis 配置文件组织**：

```
src/main/resources/
├── mybatis-config.xml          # MyBatis 主配置文件
├── mappers/                    # 映射文件目录
│   ├── UserMapper.xml          # 用户相关映射
│   ├── OrderMapper.xml         # 订单相关映射
│   └── ProductMapper.xml       # 产品相关映射
└── jdbc.properties             # 数据库连接配置
```

在 mybatis-config.xml 中采用合理的配置顺序：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <properties resource="jdbc.properties"/>
  <settings>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
    <setting name="cacheEnabled" value="true"/>
    <!-- 其他设置 -->
  </settings>
  <typeAliases>
    <package name="com.example.entity"/>
  </typeAliases>
  <plugins>
    <!-- 插件配置 -->
  </plugins>
  <environments default="development">
    <!-- 环境配置 -->
  </environments>
  <mappers>
    <package name="com.example.mapper"/>
  </mappers>
</configuration>
```

### 2. 命名规范

采用统一的命名规范：

- **表名**：使用下划线命名法，如 `user_info`、`order_item`
- **列名**：使用下划线命名法，如 `user_id`、`create_time`
- **Java 类名**：使用驼峰命名法，如 `UserInfo`、`OrderItem`
- **属性名**：使用驼峰命名法，如 `userId`、`createTime`
- **Mapper 接口**：以 `Mapper` 结尾，如 `UserMapper`、`OrderMapper`
- **映射文件**：与 Mapper 接口同名，如 `UserMapper.xml`、`OrderMapper.xml`
- **SQL 语句 ID**：与 Mapper 接口方法同名，如 `selectById`、`insertUser`

### 3. 善用类型别名

在 mybatis-config.xml 中配置类型别名，简化映射文件中的类型引用：

```xml
<typeAliases>
  <typeAlias alias="User" type="com.example.entity.User"/>
  <typeAlias alias="Order" type="com.example.entity.Order"/>
  <!-- 或者直接指定包，自动将所有类注册为别名（类名首字母小写） -->
  <package name="com.example.entity"/>
</typeAliases>
```

### 4. 数据库表设计与实体类匹配

- 确保数据库表设计与实体类属性匹配
- 使用 `mapUnderscoreToCamelCase` 设置自动映射下划线命名到驼峰命名
- 对于不匹配的字段，使用 `resultMap` 显式映射

```xml
<resultMap id="userMap" type="User">
  <id property="id" column="user_id"/>
  <result property="username" column="user_name"/>
  <result property="createdAt" column="create_time"/>
</resultMap>
```

### 5. 合理使用注解和 XML 映射

- 对于简单的 CRUD 操作，使用注解简化配置
- 对于复杂的查询，使用 XML 映射提高可读性和可维护性

```java
// 简单查询使用注解
@Select("SELECT * FROM users WHERE id = #{id}")
User selectById(Long id);

// 复杂查询使用 XML
List<User> selectUserWithRoles(Long userId);
```

## SQL 编写与优化

### 1. 利用动态 SQL

MyBatis 的动态 SQL 是其强大特性之一，合理使用可以减少代码重复：

```xml
<select id="findUsers" resultType="User">
  SELECT * FROM users
  <where>
    <if test="username != null">
      AND username LIKE #{username}
    </if>
    <if test="email != null">
      AND email = #{email}
    </if>
    <if test="status != null">
      AND status = #{status}
    </if>
  </where>
  ORDER BY id DESC
</select>
```

### 2. SQL 片段复用

对于重复的 SQL 片段，使用 `<sql>` 元素定义，通过 `<include>` 引用：

```xml
<sql id="userColumns">
  id, username, email, phone, status, create_time, update_time
</sql>

<select id="selectById" resultType="User">
  SELECT <include refid="userColumns"/>
  FROM users
  WHERE id = #{id}
</select>

<select id="selectAll" resultType="User">
  SELECT <include refid="userColumns"/>
  FROM users
</select>
```

### 3. 使用 ${} 和 #{} 的最佳实践

- 使用 `#{}` 进行参数替换，可以防止 SQL 注入
- 仅在必要时（如动态表名、排序字段）使用 `${}`，并注意验证其内容

```xml
<!-- 安全的参数替换 -->
<select id="findById" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>

<!-- 动态排序字段 -->
<select id="findAllOrderBy" resultType="User">
  SELECT * FROM users ORDER BY ${orderBy} ${orderDir}
</select>
```

对于 `${orderBy}` 和 `${orderDir}` 等变量，在使用前应该进行验证，只允许预定义的值：

```java
public List<User> findAllOrderBy(String orderBy, String orderDir) {
    // 验证排序字段
    Set<String> allowedFields = Set.of("id", "username", "create_time");
    if (!allowedFields.contains(orderBy)) {
        orderBy = "id"; // 默认排序字段
    }

    // 验证排序方向
    if (!"ASC".equalsIgnoreCase(orderDir) && !"DESC".equalsIgnoreCase(orderDir)) {
        orderDir = "DESC"; // 默认排序方向
    }

    return userMapper.findAllOrderBy(orderBy, orderDir);
}
```

### 4. 分页查询优化

使用物理分页而非内存分页，可集成 PageHelper 等分页插件：

```java
// 设置分页参数
PageHelper.startPage(pageNum, pageSize);
// 执行查询
List<User> users = userMapper.selectByCondition(condition);
// 获取分页信息
PageInfo<User> pageInfo = new PageInfo<>(users);
```

### 5. 批量操作优化

对于批量操作，使用 `foreach` 元素：

```xml
<insert id="batchInsert" parameterType="list">
  INSERT INTO users (username, email, create_time)
  VALUES
  <foreach collection="list" item="user" separator=",">
    (#{user.username}, #{user.email}, #{user.createTime})
  </foreach>
</insert>
```

对于大批量数据，考虑分批处理：

```java
public void batchInsertUsers(List<User> users) {
    int batchSize = 1000;
    for (int i = 0; i < users.size(); i += batchSize) {
        int endIndex = Math.min(i + batchSize, users.size());
        List<User> batch = users.subList(i, endIndex);
        userMapper.batchInsert(batch);
    }
}
```

## 性能优化

### 1. 缓存策略

MyBatis 提供了一级缓存和二级缓存：

- **一级缓存**：默认启用，SqlSession 级别
- **二级缓存**：需要配置，Mapper 级别（命名空间级别）

开启二级缓存：

```xml
<cache
  eviction="LRU"
  flushInterval="60000"
  size="512"
  readOnly="true"/>
```

确保实体类实现 Serializable 接口：

```java
public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    // 属性和方法
}
```

缓存使用的最佳实践：

- 对于读多写少的数据，考虑使用二级缓存
- 对于频繁修改的数据，关闭二级缓存或设置合理的刷新间隔
- 对于非常大的数据，考虑使用第三方缓存如 Redis、EhCache

### 2. 延迟加载

对于关联查询，合理使用延迟加载可以提高性能：

```xml
<!-- 全局配置延迟加载 -->
<settings>
  <setting name="lazyLoadingEnabled" value="true"/>
  <setting name="aggressiveLazyLoading" value="false"/>
</settings>

<!-- 在关联查询中使用延迟加载 -->
<resultMap id="userWithRolesMap" type="User">
  <id property="id" column="id"/>
  <result property="username" column="username"/>
  <collection property="roles" select="selectRolesByUserId" column="id" fetchType="lazy"/>
</resultMap>
```

### 3. 索引优化

确保 SQL 查询使用索引：

- 在常用查询条件字段上创建索引
- 使用 EXPLAIN 分析 SQL 执行计划
- 避免在索引字段上使用函数，如 `SUBSTRING(name, 1, 3) = 'abc'`
- 避免在索引字段上进行隐式类型转换

### 4. 结果集映射优化

针对不同场景选择合适的结果集映射方式：

- 对于简单查询，使用 `resultType` 进行自动映射
- 对于复杂查询，使用 `resultMap` 进行显式映射
- 仅查询需要的字段，避免 `SELECT *`

```xml
<!-- 简单查询使用 resultType -->
<select id="selectById" resultType="User">
  SELECT id, username, email FROM users WHERE id = #{id}
</select>

<!-- 复杂查询使用 resultMap -->
<select id="selectUserWithOrders" resultMap="userWithOrdersMap">
  SELECT u.id, u.username, o.id as order_id, o.amount
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  WHERE u.id = #{id}
</select>
```

### 5. 批处理模式

对于大量数据操作，使用批处理模式：

```java
try (SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH)) {
    UserMapper mapper = sqlSession.getMapper(UserMapper.class);
    for (User user : userList) {
        mapper.insertUser(user);
    }
    // 提交批处理
    sqlSession.flushStatements();
    sqlSession.commit();
}
```

### 6. 避免 N+1 问题

N+1 问题是指为了获取主对象的关联对象而执行了 N+1 次查询。

解决方案：

1. 使用联合查询（JOIN），一次获取所有需要的数据
2. 适当使用 IN 查询，减少查询次数

```xml
<!-- 一次性查询用户及其角色 -->
<select id="getUsersWithRoles" resultMap="userWithRolesMap">
  SELECT u.id, u.username, r.id as role_id, r.name as role_name
  FROM users u
  LEFT JOIN user_roles ur ON u.id = ur.user_id
  LEFT JOIN roles r ON ur.role_id = r.id
</select>
```

## 安全性

### 1. 防止 SQL 注入

SQL 注入是最常见的安全漏洞之一，在 MyBatis 中应该：

- 使用 `#{}` 而非 `${}` 进行参数替换
- 对于必须使用 `${}` 的场景，确保进行参数验证和转义
- 使用类型化的参数，而非字符串拼接

```xml
<!-- 安全的参数绑定 -->
<select id="findByUsername" resultType="User">
  SELECT * FROM users WHERE username = #{username}
</select>

<!-- 不安全的写法（避免） -->
<select id="findByUsername" resultType="User">
  SELECT * FROM users WHERE username = '${username}'
</select>
```

### 2. 权限控制

对于敏感操作，实施适当的权限控制：

- 数据库层面：使用有限权限的数据库账户
- 应用层面：实施细粒度的权限检查

```java
@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SecurityService securityService;

    public User getUserById(Long id) {
        User user = userMapper.selectById(id);

        // 检查当前用户是否有权限访问
        if (!securityService.canAccessUser(user)) {
            throw new AccessDeniedException("No permission to access this user");
        }

        return user;
    }
}
```

### 3. 敏感数据处理

对于敏感数据，应该加密存储和传输：

- 使用 TypeHandler 实现自动加解密
- 使用密码哈希算法存储密码
- 敏感字段返回前进行掩码处理

```java
public class EncryptedStringTypeHandler extends BaseTypeHandler<String> {

    private static final String SECRET_KEY = "your-secret-key";

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, String parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, encrypt(parameter));
    }

    @Override
    public String getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return decrypt(rs.getString(columnName));
    }

    @Override
    public String getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return decrypt(rs.getString(columnIndex));
    }

    @Override
    public String getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return decrypt(cs.getString(columnIndex));
    }

    private String encrypt(String text) {
        // 加密实现
    }

    private String decrypt(String encryptedText) {
        // 解密实现
    }
}
```

在 mybatis-config.xml 中注册类型处理器：

```xml
<typeHandlers>
  <typeHandler handler="com.example.handler.EncryptedStringTypeHandler" javaType="String" jdbcType="VARCHAR"/>
</typeHandlers>
```

## 代码组织

### 1. 分层架构

遵循清晰的分层架构：

```
com.example
├── controller    # 控制层：处理请求和响应
├── service       # 服务层：业务逻辑
├── repository    # 数据访问层：Mapper 接口
├── entity        # 实体层：数据模型
└── config        # 配置层：MyBatis 配置
```

### 2. 接口与实现分离

将接口和实现分离，提高代码的可测试性和可维护性：

```java
// 接口
public interface UserService {
    User getUserById(Long id);
    List<User> getAllUsers();
    void createUser(User user);
    void updateUser(User user);
    void deleteUser(Long id);
}

// 实现
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User getUserById(Long id) {
        return userMapper.selectById(id);
    }

    // 其他方法实现
}
```

### 3. 通用 Mapper 模式

对于常见的 CRUD 操作，可以使用通用 Mapper 模式：

```java
public interface BaseMapper<T, ID> {
    T selectById(ID id);
    List<T> selectAll();
    int insert(T entity);
    int update(T entity);
    int delete(ID id);
}

public interface UserMapper extends BaseMapper<User, Long> {
    // 特定于 User 的方法
    List<User> selectByUsername(String username);
}
```

使用 MyBatis-Plus 或 tk.mybatis 等框架可以更容易实现此模式。

### 4. 合理使用 XML 和注解

根据复杂度选择合适的方式：

- 简单的 CRUD 操作使用注解
- 复杂的查询和动态 SQL 使用 XML

```java
@Mapper
public interface UserMapper {

    @Select("SELECT * FROM users WHERE id = #{id}")
    User selectById(Long id);

    @Insert("INSERT INTO users(username, email) VALUES(#{username}, #{email})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);

    // 复杂查询使用 XML
    List<User> selectWithFilters(UserQueryFilter filter);
}
```

### 5. DTO 和实体分离

将数据传输对象（DTO）和实体对象分离：

```java
// 实体类（映射数据库表）
@Data
public class User {
    private Long id;
    private String username;
    private String password;  // 加密的密码
    private String email;
    private Date createTime;
    private Date updateTime;
}

// DTO（用于 API 交互）
@Data
public class UserDTO {
    private Long id;
    private String username;
    private String email;
    // 不包含敏感信息如密码
}
```

使用映射工具如 MapStruct 进行对象转换：

```java
@Mapper
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserDTO toDTO(User user);
    User toEntity(UserDTO dto);

    // 批量转换
    List<UserDTO> toDTOList(List<User> users);
}
```

## 测试策略

### 1. 单元测试

为 Mapper 接口编写单元测试：

```java
@RunWith(SpringRunner.class)
@MybatisTest
public class UserMapperTest {

    @Autowired
    private UserMapper userMapper;

    @Test
    public void testSelectById() {
        // 准备测试数据
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        userMapper.insert(user);

        // 执行测试
        User foundUser = userMapper.selectById(user.getId());

        // 验证结果
        assertNotNull(foundUser);
        assertEquals("testuser", foundUser.getUsername());
        assertEquals("test@example.com", foundUser.getEmail());
    }
}
```

### 2. 集成测试

测试 MyBatis 与其他组件的集成：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class UserServiceIntegrationTest {

    @Autowired
    private UserService userService;

    @Test
    public void testCreateAndGetUser() {
        // 创建用户
        User user = new User();
        user.setUsername("integrationtest");
        user.setEmail("integration@example.com");
        userService.createUser(user);

        // 获取用户
        User foundUser = userService.getUserById(user.getId());

        // 验证结果
        assertNotNull(foundUser);
        assertEquals("integrationtest", foundUser.getUsername());
    }
}
```

### 3. 使用内存数据库

对于单元测试，可以使用内存数据库如 H2：

```xml
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>2.1.214</version>
    <scope>test</scope>
</dependency>
```

配置测试数据源：

```java
@Configuration
public class TestDatabaseConfig {

    @Bean
    public DataSource dataSource() {
        return new EmbeddedDatabaseBuilder()
            .setType(EmbeddedDatabaseType.H2)
            .addScript("schema.sql")
            .addScript("test-data.sql")
            .build();
    }
}
```

### 4. 使用 DbUnit 管理测试数据

使用 DbUnit 可以更好地管理测试数据：

```java
@RunWith(SpringRunner.class)
@DbUnitConfiguration(dataSetLoader = FlatXmlDataSetLoader.class)
@DatabaseSetup("classpath:sample-data.xml")
public class UserMapperDbUnitTest {

    @Autowired
    private UserMapper userMapper;

    @Test
    public void testFindByUsername() {
        List<User> users = userMapper.findByUsername("testuser");
        assertEquals(1, users.size());
        assertEquals("test@example.com", users.get(0).getEmail());
    }

    @Test
    @DatabaseSetup("classpath:multiple-users.xml")
    public void testFindMultipleUsers() {
        List<User> users = userMapper.findAll();
        assertEquals(3, users.size());
    }
}
```

## 与其他框架集成

### 1. Spring Boot 集成

在 Spring Boot 项目中，集成 MyBatis 非常简单：

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.2.2</version>
</dependency>
```

配置示例：

```properties
# application.properties
mybatis.config-location=classpath:mybatis-config.xml
mybatis.mapper-locations=classpath:mappers/**/*.xml
mybatis.type-aliases-package=com.example.entity
```

或使用 Java 配置：

```java
@Configuration
@MapperScan("com.example.mapper")
public class MyBatisConfig {

    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource);
        factoryBean.setMapperLocations(
            new PathMatchingResourcePatternResolver().getResources("classpath:mappers/**/*.xml")
        );
        factoryBean.setTypeAliasesPackage("com.example.entity");
        return factoryBean.getObject();
    }
}
```

### 2. Spring 事务管理

与 Spring 事务管理集成：

```java
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Transactional
    @Override
    public void createUser(User user) {
        userMapper.insert(user);
        // 其他操作
    }

    @Transactional(readOnly = true)
    @Override
    public User getUserById(Long id) {
        return userMapper.selectById(id);
    }
}
```

### 3. 与分页框架集成

集成 PageHelper 分页框架：

```xml
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper-spring-boot-starter</artifactId>
    <version>1.4.2</version>
</dependency>
```

使用示例：

```java
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public PageInfo<User> getUsersByPage(int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> users = userMapper.selectAll();
        return new PageInfo<>(users);
    }
}
```

### 4. 与数据库连接池集成

集成 HikariCP 连接池：

```java
@Configuration
public class DataSourceConfig {

    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/myapp");
        config.setUsername("root");
        config.setPassword("password");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(5);
        config.setConnectionTimeout(30000);
        return new HikariDataSource(config);
    }
}
```

## 常见陷阱与解决方案

### 1. N+1 查询问题

问题：查询主表记录后，循环查询关联表记录，导致多次数据库访问。

解决方案：

- 使用联合查询一次性获取所有需要的数据
- 使用批量查询减少查询次数

```xml
<!-- 问题代码 -->
<select id="getUser" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>

<select id="getOrdersByUserId" resultType="Order">
  SELECT * FROM orders WHERE user_id = #{userId}
</select>

<!-- 改进后的代码 -->
<select id="getUserWithOrders" resultMap="userWithOrdersMap">
  SELECT u.*, o.*
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  WHERE u.id = #{id}
</select>
```

### 2. 大批量数据处理

问题：一次处理大量数据导致内存溢出或性能问题。

解决方案：

- 分批处理数据
- 使用流式查询（Cursor）

```java
// 分批处理
public void processBatchData(List<User> users) {
    int batchSize = 500;
    int totalSize = users.size();

    for (int i = 0; i < totalSize; i += batchSize) {
        int endIndex = Math.min(i + batchSize, totalSize);
        List<User> batch = users.subList(i, endIndex);
        userMapper.batchInsert(batch);
    }
}

// 流式查询
public void processLargeData() {
    try (SqlSession session = sqlSessionFactory.openSession();
         Cursor<User> cursor = session.getMapper(UserMapper.class).scanAllUsers()) {

        for (User user : cursor) {
            processUser(user);
        }
    } catch (IOException e) {
        // 处理异常
    }
}
```

### 3. 日期和时间类型处理

问题：不同数据库的日期时间类型处理不一致。

解决方案：

- 使用 Java 8 的新日期时间 API
- 配置相应的 TypeHandler

```java
// 在实体类中使用 Java 8 日期时间类型
public class User {
    private Long id;
    private String username;
    private LocalDateTime createTime;
    private LocalDate birthDate;
}

// 注册类型处理器
@Configuration
public class MyBatisConfig {

    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        SqlSessionFactoryBean factory = new SqlSessionFactoryBean();
        factory.setDataSource(dataSource);

        // 注册 Java 8 日期时间类型处理器
        TypeHandlerRegistry typeHandlerRegistry = factory.getObject().getConfiguration().getTypeHandlerRegistry();
        typeHandlerRegistry.register(LocalDateTime.class, new LocalDateTimeTypeHandler());
        typeHandlerRegistry.register(LocalDate.class, new LocalDateTypeHandler());

        return factory.getObject();
    }
}
```

### 4. 多数据源配置

问题：在一个应用中需要访问多个数据库。

解决方案：

- 配置多个 SqlSessionFactory
- 使用动态数据源切换

```java
@Configuration
public class MultiDataSourceConfig {

    @Bean
    @Primary
    @ConfigurationProperties("spring.datasource.primary")
    public DataSource primaryDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @ConfigurationProperties("spring.datasource.secondary")
    public DataSource secondaryDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @Primary
    public SqlSessionFactory primarySqlSessionFactory(
            @Qualifier("primaryDataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource);
        factoryBean.setMapperLocations(
            new PathMatchingResourcePatternResolver().getResources("classpath:mappers/primary/**/*.xml")
        );
        return factoryBean.getObject();
    }

    @Bean
    public SqlSessionFactory secondarySqlSessionFactory(
            @Qualifier("secondaryDataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource);
        factoryBean.setMapperLocations(
            new PathMatchingResourcePatternResolver().getResources("classpath:mappers/secondary/**/*.xml")
        );
        return factoryBean.getObject();
    }
}
```

### 5. 枚举类型处理

问题：Java 枚举类型与数据库字段的映射。

解决方案：

- 自定义 TypeHandler 处理枚举类型

```java
// 枚举类
public enum UserStatus {
    ACTIVE(1),
    INACTIVE(0),
    LOCKED(2);

    private final int value;

    UserStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static UserStatus valueOf(int value) {
        for (UserStatus status : values()) {
            if (status.getValue() == value) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid UserStatus value: " + value);
    }
}

// 类型处理器
public class UserStatusTypeHandler extends BaseTypeHandler<UserStatus> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, UserStatus parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getValue());
    }

    @Override
    public UserStatus getNullableResult(ResultSet rs, String columnName) throws SQLException {
        int value = rs.getInt(columnName);
        return rs.wasNull() ? null : UserStatus.valueOf(value);
    }

    @Override
    public UserStatus getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        int value = rs.getInt(columnIndex);
        return rs.wasNull() ? null : UserStatus.valueOf(value);
    }

    @Override
    public UserStatus getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        int value = cs.getInt(columnIndex);
        return cs.wasNull() ? null : UserStatus.valueOf(value);
    }
}
```

注册类型处理器：

```xml
<typeHandlers>
  <typeHandler handler="com.example.handler.UserStatusTypeHandler" javaType="com.example.enums.UserStatus" jdbcType="INTEGER"/>
</typeHandlers>
```

## 小结

本文介绍了 MyBatis 的最佳实践，涵盖了配置与设计、SQL 编写与优化、性能优化、安全性、代码组织、测试策略以及与其他框架的集成等方面。通过遵循这些最佳实践，可以更高效、安全地使用 MyBatis 框架，构建出高质量的数据访问层。

在实际项目中，应该根据具体需求和场景，灵活应用这些最佳实践，不断优化和改进使用 MyBatis 的方式，以获得最佳的开发体验和应用性能。

