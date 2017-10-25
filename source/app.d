/*
 * D Brainfuck interpreter
 * 
 * Copyright 2015 Jakub Groncki <jakub.groncki@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
module bfd.main;

import std.stdio;
import std.file;

void main(string[] args)
{
    
    // Load instructions
    // (In D args[0] is occupied by program name)
    if (args.length > 1) {
        try {
            // Program's code
            char[] code = cast(char[])read(args[1]);
            interpret(code);
        } catch (FileException e) {
            writefln("Could not open file: %s\n%s", args[1], e.msg);
        } 
    } else {
        writeln("Usage: bfd [filename]");
        return;
    }
}

void interpret(char[] code)
{
    char[30_000] cells = 0;
    char *elem = &cells[0];
    
    char *cur = &code[0];
    ushort loop;
    
    while (*cur) {
        switch(*cur) {
            case '>':
                ++elem;
                break;
            case '<':
                --elem;
                break;
            case '+':
                ++(*elem);
                break;
            case '-':
                --(*elem);
                break;
            case '.':
                writef("%c", *elem);
                break;
            case ',':
                readf(" %s", elem);
                break;
            case '[':
                if (!*elem) {
                    loop = 1;
                    while (loop) {
                        ++cur;
                        if (*cur == '[') ++loop;
                        if (*cur == ']') --loop;
                    }
                }
                break;
            case ']':
                if (*elem) {
                    loop = 1;
                    while (loop) {
                        --cur;
                        if (*cur == ']') ++loop;
                        if (*cur == '[') --loop;
                    }
                }
                break;
            default:
                break;
        }
        ++cur;
    }
}