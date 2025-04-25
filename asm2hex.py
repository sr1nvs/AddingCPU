import sys

OPCODES = {
    'lda': 0b00,
    'sta': 0b01,
    'jmp': 0b10,
    'add': 0b11
}

def parse_line(line):

    parts = line.strip().split()
    if not parts or parts[0].startswith('//'):
        return None
    
    addr = int(parts[0], 16)
    if parts[1] == ':::':
        return addr, int(parts[2], 16)
    
    opcode = OPCODES.get(parts[1].lower())
    if opcode is None:
        raise ValueError(f"Unknown opcode: {parts[1]}")
    
    operand = int(parts[2], 16)

    return addr, (opcode << 6) | (operand & 0x3F) # 2 bits of opcode, 6 bits of operand

def main():
    if len(sys.argv) != 3:
        print("python asm2hex.py input.txt output.hex")
        sys.exit(1)
        
    memory = [0x00] * 64

    with open(sys.argv[1]) as fin:
        for line in fin:
            parsed = parse_line(line)
            if parsed:
                addr, value = parsed
                memory[addr] = value

    with open(sys.argv[2], 'w') as fout:
        for val in memory:
            fout.write(f"{val:02X}\n")

if __name__ == "__main__":
    main()
