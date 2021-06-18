def yuu(a,b)
   if a%b ==0 then return b
     return yuu(b,a%b)
   end
end
