def Fizzbuzz(n)
    if n>0 then
        Fizzbuzz(n-1)
    end


    if n%3==0 && n%5==0 then
        puts("Fizzbuzz")
    elsif n%3==0 then
        puts("Fizz")
    elsif n%5==0 then
        puts("buzz")
    else
        puts(n)
    end
end
puts("整数を入力してください")
Num = gets.to_i
Fizzbuzz(Num)
