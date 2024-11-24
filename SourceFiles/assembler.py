def get_opcode(ins):
    r = {'add':32,'addu':33,'sub':34,'subu':35,'mul':24,'mulu':25,'div':26,'divu':27,'slt':42,'sltu':43,'and':36,'or':37,'nor':39,'xor':40,'mfhi':28,'mflo':29,'dfhi':30,'dflo':31,'lsl':44,'asr':45,'lsr':46}
    i = {'addi':8,'addiu':9,'slti':10,'sltiu':11,'andi':12,'ori':13,'xori':14,'lw':35,'sw':43,'beq':4,'bne':5,'blez':6,'bgtz':7,'bltz':1,'bgez':3}
    j = {'j':2}

    if ins in r.keys():
        a = 'r'+bin(r[ins])[2:].zfill(6)
    elif ins in i.keys():
        a = 'i'+bin(i[ins])[2:].zfill(6)
    elif ins in j.keys():
        a = 'j'+bin(j[ins])[2:].zfill(6)
    else:
        a = 'inv'

    return a

f1 = open("inst.txt","r").read().split('\n')
f = open("codes.txt","w")

for inst in f1:
    inst = inst.strip().upper()

    if '[' not in inst:
        inst = inst.split()
    else:
        inst = inst.replace('[',' ').replace(']',' ').split()
        inst[-1],inst[-2] = inst[-2],inst[-1]
        inst[-2],inst[-3] = inst[-3],inst[-2]

    if (inst[0].lower()=='nop'):
        f.write('00000000\n')
        continue

    if (inst[0].lower()=='li'):
        inst[0] = 'ADDI'
        inst.insert(1,'R0')
        
    print(inst)
    op = get_opcode(inst[0].lower())
    if op == "inv":
        print("Invalid Instruction")
        exit(0)

    if op[0]=='r':
        opcode = '0'*6
        shamt = '0'*5 
        
        arr1 = ['mfhi','mflo','dfhi','dflo']
        arr = ['mul','mulu','div','divu']
        arr2 = ['lsl','asr','lsr']
        
        if inst[0].lower() in arr1:
            arg1 = '0'*5
            arg2 = '0'*5
            arg3 = bin(int(inst[1][1:]))[2:].zfill(5) 

        elif inst[0].lower() in arr:
            arg1 = bin(int(inst[1][1:]))[2:].zfill(5) 
            arg2 = bin(int(inst[2][1:]))[2:].zfill(5) 
            arg3 = '0'*5 

        elif inst[0].lower() in arr2:
            arg1 = bin(int(inst[2][1:]))[2:].zfill(5)
            arg2 = '0'*5
            arg3 = bin(int(inst[1][1:]))[2:].zfill(5)
            shamt = bin(int(inst[3]))[2:].zfill(5)

        else:
            arg1 = bin(int(inst[1][1:]))[2:].zfill(5) 
            arg2 = bin(int(inst[2][1:]))[2:].zfill(5) 
            arg3 = bin(int(inst[3][1:]))[2:].zfill(5)

        ans = opcode+arg1+arg2+arg3+shamt+op[1:]
        f.write(hex(int(ans,2))[2:].upper().zfill(8))

    elif op[0]=='i':
        arg1 = bin(int(inst[1][1:]))[2:].zfill(5)

        arr = ['blez','bgtz','bltz','bgez']
        if inst[0].lower() in arr:
            arg2 = '0'*5
            arg3 = bin(int(inst[2]))[2:].zfill(16)
        else:
            arg2 = bin(int(inst[2][1:]))[2:].zfill(5)
            arg3 = bin(int(inst[3]))[2:].zfill(16)

        ans = op[1:]+arg1+arg2+arg3
        f.write(hex(int(ans,2))[2:].upper().zfill(8))

    elif op[0]=='j':
        arg1 = bin(int(inst[1]))[2:].zfill(26)
        ans = op[1:]+arg1
        f.write(hex(int(ans,2))[2:].upper().zfill(8))

    else:
        print("Invalid Instruction")
        exit(0)
    f.write('\n')
f.close()
