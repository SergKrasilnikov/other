########################
#1
# var = 0
# for i in range(1, 10):
#     var += i
#     i += 1
# print(var)

########################
#2
# a = 0
# cou = 0
# for i in [700, 0, 8, 89, 20, 13]:
#     if i == 0:
#         a += 1
#         i += 1
#         cou = a
# print (cou)

########################
#3
# n = 3
# if n > 9 or n < 1:
#     print("Еrrоr")
# else:
#     s = ''
#     for i in range(1, n+1):
#         s += str(i)
#         print(s)

########################
#4
n = 5
if n > 9 or n < 1:
    print("Еrrоr")
else:
    s = ''
    h = ' '
    i = 1
    while(i <= n):
        for i in range(1, n+1):
            s += str(i)
            if i == n:
                s -= str(i)
            print(s)