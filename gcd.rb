def yuu(a,b)
   if a%b ==0 then return b
     return yuu(b,a%b)
   end
end




def kaku(a,b)
  if a%b ==0 then return b
    #if条件を満たし他時のq,rを返す処理をかく
    return kaku(b,a%b)
  end
end

def fer(a,p)
  b=a**(p-1)/p
  #割り切れるまでの処理追加
  return b
end

