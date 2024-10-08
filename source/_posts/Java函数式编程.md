---
title: Java函数式编程
mathjax: true
date: 2024-10-02 13:12:13
categories:
tags:
- Java
---
函数式编程是一种“编程范式”，以函数为基本构建单元。在这种范式中，函数可以作为参数传递给其他函数、作为返回值返回，或赋值给变量。

> 由于Java不支持单独定义函数，我们可以将静态方法视为独立的函数，将实例方法视为自带`this`参数的函数。（**from** [函数式编程 - Java教程 - 廖雪峰的官方网站](https://liaoxuefeng.com/books/java/functional/index.html)）

Java8引入了对函数式编程的支持，主要包括以下几个方面：

- 函数式接口：允许在方法中传递行为。
- Lambda表达式：允许用简洁的方式来表示函数，简化了匿名内部类的写法。
- Stream API：支持对集合进行函数式操作，如过滤、映射、聚合等，并且支持使用并行流提高性能。
- Optional：用于处理可能为null的值，避免`NullPointerException`。

<!-- more -->

# 函数式接口

函数式接口是仅包含一个方法的接口，只提供一个功能，通过这些接口我们可以实现行为在方法间的传递。比如Runnable、Comparable、Callable都可以视为函数式接口。

Java 8引入了`java.util.function`包，包含多个常用的函数式接口：`Function<T,R>`、`Consumer<T>`、`Supplier<T>`，`Predicate<T>`、`UnaryOperator<T>`、`BinaryOperator<T>`，并且在Java 8之后可以用lambda表达式来进行实例化。

```Java
public class LambdaTest {
    public static void main(String[] args) {
        // 1. Function<T, R> 接收一个T类型的参数，返回一个R类型的结果
        Function<Integer, String> intToString= Objects::toString;
        System.out.println(intToString.apply(123));

        // 2. Consumer<T> 接收一个T类型的参数，不返回结果，通常用于执行某些操作
        Consumer<String> print = System.out::println;
        print.accept("Hello, World!");
        // 3. BiConsumer<T, U> 接收两个参数，不返回结果
        BiConsumer<String, String> concat = (a, b) -> System.out.println(a + b);
        concat.accept("Hello, ", "World!");

        // 4. Supplier<T> 不接收参数，返回一个T类型的结果
        Supplier<Double> random = Math::random;
        System.out.println(random.get());

        // 5. Predicate<T> 接收一个T类型的参数，返回一个boolean类型的结果
        Predicate<Integer> isEven = i -> i % 2 == 0;
        System.out.println(isEven.test(2));
        // 6. BiPredicate<T, U> 接收两个参数，返回一个boolean类型的结果
        BiPredicate<Integer, Integer> isGreater = (a, b) -> a > b;
        System.out.println(isGreater.test(2, 1));

        // 7. UnaryOperator<T> 接收一个T类型的参数，返回一个T类型的结果
        UnaryOperator<Integer> square = i -> i * i;
        System.out.println(square.apply(3));
        // 8. BinaryOperator<T> 接收两个T类型的参数，返回一个T类型的结果
        BinaryOperator<Integer> add = (a, b) -> a + b;
        System.out.println(add.apply(1, 2));
    }
}
```

# Lambda表达式

Lambda表达式是Java 8引入的一种语法，用于简化函数式编程中匿名内部类的使用。

```java
// 匿名内部类写法
Runnable r=new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello, World!");
    }
};
// Lambda写法
r=()->System.out.println("Hello, World!");
```

除此之外，还提供了方法引用，可以进一步简化对现有方法的引用。

```java
Function<Double, Double> sqrt = Math::sqrt; // 静态方法引用
String str = "Hello, World!";
Supplier<Integer> stringLength = str::length; // 实例方法引用
BiPredicate<String, String> equals = String::equals;
Supplier<List<String>> listSupplier = ArrayList::new;
```

# Stream API

Stream API支持对集合进行函数式操作，如过滤、映射、聚合等，并且支持使用并行流提高性能。

一般包括三步：创建流、中间操作、终止操作。

```java
class StreamTest {
    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        List<Integer> list = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        // 1. 创建流
        // 1.1 通过集合创建流
        List<Integer> collect = list.stream().map(i -> i * i).collect(Collectors.toList());
        // list.stream().map(i -> i * i).toList(); toArray();
        // 1.2 通过数组创建流
        Arrays.stream(arr)
              .filter(i -> i % 2 == 0)
              .min()
              .ifPresentOrElse(System.out::println, () -> System.out.println("No even number"));
        // 1.3 通过Stream.of()创建流
        long count = Stream.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10).count();
        System.out.println(count);
        // 1.4 创建无限流
        Stream.generate(Math::random).limit(10).forEach(System.out::println);

        // 2. 中间操作：filter, map, limit, skip, distinct, sorted, peek
        List<Integer> collect1 = Stream.of(3, 8, 10, 6, 2, 7, 1, 9, 4, 5).filter(i -> i % 2 == 0) // 条件过滤
                                       .map(i -> i * i) // 映射操作
                                       .limit(3) // 限制数量
                                       .skip(1) // 跳过
                                       .distinct() // 去重
                                       .sorted() // 排序
                                       .peek(System.out::println) // 调试：需要注意peek参数是Consumer类型，没有返回值
                                       .toList();

        // 3. 终止操作：forEach, count, collect, reduce, min, max, findFirst, findAny, anyMatch, allMatch, noneMatch
        list.stream().forEach(System.out::println);
        long count1 = list.stream().count();
        List<Integer> collect2 = list.stream().collect(Collectors.toList());

        int sum = list.stream().reduce(0, Integer::sum); // reduce()接收一个初始值和一个BinaryOperator，返回一个结果

        int min = list.stream().min(Integer::compareTo).orElse(-1);
        int max = list.stream().max(Integer::compareTo).orElse(-1);

        int first = list.stream().findFirst().orElse(-1); // findFirst()返回第一个元素
        int any = list.stream().findAny().orElse(-1); // findAny()返回任意一个元素

        boolean anyMatch = list.stream().anyMatch(i -> i % 2 == 0); // anyMatch()判断是否有一个元素满足条件
        boolean allMatch = list.stream().allMatch(i -> i % 2 == 0); // allMatch()判断是否所有元素满足条件
        boolean noneMatch = list.stream().noneMatch(i -> i % 2 == 0); // noneMatch()判断是否所有元素都不满足条件
    }
}
```

## 区分`map`、`reduce`、`collect`

- `map`是一个中间操作，用于将流中的每个元素应用给定的函数，转换为另一种类型或形式，返回流。
- `reduce`是一个终止操作，用于将流中的所有元素聚合成一个单一的值，通常用于计算总和、乘积等，返回`Optional`。
- `collect`是一个终止操作，用于将流中的元素收集到一个集合、字符串或其他形式的结果，通常用于转换流为可用的数据结构。

# Optional

在Stream的部分终止操作会返回Optional，比如max\min\findFirst\findAny

```java
class OptionalTest{
    public static void main(String[] args) {
        // 1. 创建Optional对象
        Optional<String> optional = Optional.of("Hello, World!");
        Optional<String> empty = Optional.empty();
        Optional<String> nullable = Optional.ofNullable(null);
        // 2. 判断是否有值
        System.out.println(optional.isPresent());
        System.out.println(empty.isEmpty());
        // 3. 获取值
        System.out.println(optional.get());
        System.out.println(empty.orElse("No value"));
        System.out.println(nullable.orElseGet(() -> "No value"));
        // 4. 转换
        Optional<Integer> length = optional.map(String::length);
        Optional<String> upper = optional.flatMap(s -> Optional.of(s.toUpperCase()));
        // 5. 过滤
        Optional<String> filter = optional.filter(s -> s.length() > 5);
        // 6. 如果有值则执行
        optional.ifPresent(System.out::println);
        // 7. 如果有值则执行，否则执行
        optional.ifPresentOrElse(System.out::println, () -> System.out.println("No value"));
    }
}
```

# 例子

```java
public static int sumOfEvenNumbers(List<Integer> numbers) {
    // 求偶数和
    // return numbers.stream().filter(i->i%2==0).reduce(0, Integer::sum);
    // return numbers.stream().filter(i -> i % 2 == 0).reduce(0, (a, b) -> a + b);
    return numbers.stream().filter(i -> i % 2 == 0).mapToInt(Integer::intValue).sum();

}

public static int getLength(Optional<String> optionalString) {
    // 求字符串长度，如果为空则返回0
    return optionalString.map(String::length).orElse(0);
}


public static List<String> convertToUpperCase(List<String> strings) {
    // 转化为大写
    return strings.stream().map(String::toUpperCase).toList();
}

public static int findMinimum(List<Integer> numbers) {
    // 找到最小值
    return numbers.stream().min(Integer::compareTo).orElse(Integer.MIN_VALUE);
}
```

