

# Verilog知识点总结

[TOC]



## **1.存器的避免以及原因**

[原文链接](http://t.csdnimg.cn/h95Uy)


原因

​	**可预测的时序行为：**
​		锁存器的输出取决于输入信号的持续电平，而不是特定的时钟边沿。这意味着锁存器的输出可能会在任意时刻改变，这使得时序分析和预测更加困难。

​	**易受毛刺影响：**
​		由于锁存器的输出直接由输入决定，任何输入上的噪声或毛刺都会立即反映到输出上，可能导致系统不稳定或误操作。

​	**难以进行静态时序分析（STA）：**
​		时序分析工具主要用于检查时序逻辑，其中输出在时钟边沿更新。锁存器的存在使得自动工具难以准确预测电路的行为，增加了设计验证的难度。

​	**不利于FPGA资源利用：**
​		FPGA内部的锁存器实现通常不如寄存器那样高效。FPGA硬件通常为寄存器提供专用的资源（如FF或触发器），而锁存器可能需要更多的通用逻辑资源，这可能降低资源利用率和增加功耗。

​	**可能违反设计规范：**
​		大多数FPGA设计指南建议避免使用锁存器，因为它们可能引入上述问题。使用锁存器可能违反团队或项目的设计规则，导致额外的审查和修改工作。

解决措施

- 确保所有的`if`语句都有相应的`else`分支。
- 对`case`语句添加`default`项。
- 使用阻塞赋值（`=`）来明确表达组合逻辑，或者确保非阻塞赋值（`<=`）在`always`块中有完整的敏感信号列表。
- 将时序逻辑和组合逻辑分离，确保所有的时序逻辑都在适当的时钟边缘或事件触发下更新状态。

## 2.**符号分析**

**`-12'h123`**：这是将一个无符号的 `12'h123` 通过加负号来表示为负数，结果是 16‘FEDD。

**`12'shEDD`**：这是一个带符号的数，最高位是 `1`，表示为负数，数值为 16’FEDD。

## 3.**线网与变量**

**`wire`** 适用于单一驱动信号的连接，广泛用于简单的信号传输。

**`tri`** 则适合在总线设计或多个模块共享同一信号线的场景下使用，允许信号线在不同驱动源之间切换

| **属性**     | **wire**                         | **tri**                                    |
| ------------ | -------------------------------- | :----------------------------------------- |
| **驱动**     | 只能由一个源驱动                 | 可以被多个源驱动，但同一时刻只有一个驱动源 |
| **默认值**   | 默认值是 `z`，但只能有一个驱动源 | 默认值是 `z`，可被多个驱动源控制           |
| **应用场景** | 通常用于单一驱动源的信号传输     | 通常用于总线、多驱动源的场景               |
| **使用场景** | 普通逻辑信号，模块输出，组合逻辑 | 总线信号，三态逻辑                         |

## 4.**异或技巧**

和0异或结果是他本身，和1异或是取反

## **5. generate语句使用方法**

  1. **`generate` 语句的基本用法**

`generate` 语句块用于在设计时根据条件生成逻辑硬件，不是像过程块（`always` 块）那样实时响应输入变化。它在**综合**时将生成具体的硬件电路，而不是动态执行逻辑。

 语法结构：

```verilog
generate
    // 生成逻辑的代码块
endgenerate
```

在 `generate` 语句块中，常用的是 `for` 循环、`if` 条件判断和 `case` 语句，它们可以用来控制模块的生成。

  2. **使用 `generate` 和 `for` 语句进行模块实例化**

`generate` 块常常配合 `for` 循环使用，主要用于批量生成相同类型的硬件结构。例如，实例化多个相同的全加器、寄存器或其他模块。

 例子：使用 `generate` 和 `for` 生成 8 个 1 位全加器

```verilog
module top_module(
    input [7:0] a, b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry; // 中间的进位信号

    genvar i; // 声明一个变量用于生成循环
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            if (i == 0) begin
                full_adder fa0 (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
            else begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[7]; // 最后一位的进位作为最终输出
endmodule
```

 解释：

- **`genvar i`**：`genvar` 是一种特殊的数据类型，表示一个生成变量，它仅用于 `generate` 块中的循环控制，不是硬件信号。
- **`for` 循环**：通过 `generate` 块和 `for` 循环来实例化 8 个全加器模块，每个全加器的输入和输出信号是不同的。
- **`if` 条件**：在循环中用 `if` 来处理特殊的边界情况，比如第一个加法器的 `cin` 是外部输入，而后续的加法器 `cin` 则来自前一个加法器的 `cout`。
- **`adder_chain`**：这是一个命名块，给生成的每个模块实例化加了一个名字 `adder_chain`，每个实例会自动获得一个索引（如 `adder_chain[0]`、`adder_chain[1]`）。

  3. **使用 `generate` 和 `if` 语句进行条件模块生成**

`generate` 块中的 `if` 语句用于基于条件选择是否生成特定的硬件结构。它通常用于参数化设计中，允许你根据不同的输入参数生成不同的电路结构。

 例子：条件生成不同位宽的加法器

```verilog
module top_module #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a, b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    generate
        if (WIDTH == 8) begin
            // 生成一个8位加法器
            full_adder_8bit adder8 (
                .a(a),
                .b(b),
                .cin(cin),
                .sum(sum),
                .cout(cout)
            );
        end
        else if (WIDTH == 16) begin
            // 生成一个16位加法器
            full_adder_16bit adder16 (
                .a(a),
                .b(b),
                .cin(cin),
                .sum(sum),
                .cout(cout)
            );
        end
        else begin
            // 默认生成一个4位加法器
            full_adder_4bit adder4 (
                .a(a[3:0]),
                .b(b[3:0]),
                .cin(cin),
                .sum(sum[3:0]),
                .cout(cout)
            );
        end
    endgenerate

endmodule
```

 解释：

- **`if` 条件**：`generate` 块中的 `if` 条件决定不同位宽的加法器模块的生成。如果 `WIDTH` 是 8，则生成 8 位加法器；如果是 16，则生成 16 位加法器；否则生成默认的 4 位加法器。
- 这里的 `if` 判断发生在设计编译阶段，具体生成哪个模块是在编译时决定的，而不是在运行时动态变化。

  4. **使用 `generate` 和 `case` 语句**

`generate` 语句也可以和 `case` 语句一起使用，以实现基于某个参数或信号的不同硬件结构生成。

 例子：使用 `generate` 和 `case` 生成不同的算术单元

```verilog
module top_module #(parameter OPERATION = 0) (
    input [3:0] a, b,
    output reg [3:0] result
);

    generate
        case (OPERATION)
            0: begin
                // 加法操作
                assign result = a + b;
            end
            1: begin
                // 减法操作
                assign result = a - b;
            end
            2: begin
                // 按位与操作
                assign result = a & b;
            end
            3: begin
                // 按位或操作
                assign result = a | b;
            end
            default: begin
                // 默认操作
                assign result = 4'b0000;
            end
        endcase
    endgenerate

endmodule
```

 解释：

- **`case` 语句**：根据 `OPERATION` 参数的值，生成不同的运算逻辑。例如，`OPERATION` 为 0 时生成加法逻辑，为 1 时生成减法逻辑。
- **不同操作逻辑**：在不同的操作下，生成了不同的组合逻辑单元，如加法、减法、按位与或按位或运算。

5. **`generate` 的使用规则**

- **`genvar` 类型**：`genvar` 是生成循环变量的特殊类型，仅在 `generate` 块中有效，它用于控制 `for` 循环的迭代。
- **`generate` 块必须配对使用**：即必须有 `generate` 和 `endgenerate`，尽管在某些编译器中可以省略 `endgenerate`，但建议显式书写。
- **不允许动态条件判断**：`generate` 块中的条件判断（如 `if` 和 `case`）是在编译时确定的，它们不能基于时钟或输入信号变化进行实时判断。
- **`generate` 块的输出信号**：在 `generate` 块中生成的信号，和正常模块中生成的信号一样，可以通过 `assign` 语句或组合逻辑块进行连接。

  6. **总结**

- `generate` 块主要用于**结构化设计**，它允许你根据条件生成多个硬件模块，或者批量实例化相同类型的模块。
- `for` 循环通常用于生成一系列相同类型的模块，而 `if` 和 `case` 语句则用于条件选择生成不同的模块。
- `generate` 语句中的逻辑是在**设计时**决定的，而不是在运行时动态变化的。

通过使用 `generate` 块，设计者可以更高效地管理大规模的硬件设计，尤其是当模块的结构具有重复性或依赖某些静态参数时。

## **6.数组使用**

```verilog
module top_module (
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different
);

    assign out_any = in[3:1] | in[2:0];
    assign out_both = in[2:0] & in[3:1];
    assign out_different = in ^ {in[0], in[3:1]};
    
endmodule

```
通过对数组整体的操作，达到目的，比起按位数来一位一位赋值高效很多，在v的学习中这个很重要

## 7.表达式位长

表达式的位长一般取决于左值的位宽，但是在一些情况会取决于表达式本身，例如当出现`{}`时，右边的最终值取决于{}内的位宽，但实例中只有一个表达式，因此为4

```Verilog
reg [3:0] a;//a=4'hf
reg [3:0] b;//b=4'ha
reg [15:0]c;
//a**b=86 430A AC61
c=a**b;//c=ac61
c={a**b};//c=1
```

 8.表达式位长

- **+**运算既可以表示有符号也可以表示无符号，如果右值中所有操作数都是有符号数，那就执行符号加法，如果有无符号数，所有操作数被强制成无符号数，执行无符号加法1’b1是无符号的
- 在verilog中如果一个数字没有base 被认为有符号的10进制数，如果有base无符号则是无符号数 

## 8.位切片操作

在verilog中**`out = in[x*4+:4]`;**代表取出in[x],in[x+1],in[x+2],in[x+3],而out = in[selx4+4:selx4];是错误的，因为verilog需要位宽范围是常数，只能用这种特殊方法