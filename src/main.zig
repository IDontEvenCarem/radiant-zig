const std = @import("std");

const Token = struct {

};

const ParseContext = struct {
    alloc: std.mem.Allocator,
    
    pub fn init (alloc: std.mem.Allocator) ParseContext {
        return ParseContext{
            .alloc = alloc
        };
    }

    pub fn readText(text: []u8) void {
        _ = text;
    }

    pub fn getTokens() []Token {
        
    }
};

pub fn main() !void {
    var gpio = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpio.deinit();
    var alloc = gpio.allocator();

    var args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var parseCtx = ParseContext.init(alloc);
    _ = parseCtx;
    if (args.len == 1) {
        // run the REPL
    }
    else if (args.len == 2) {
        // open the file
        var filename = args[1];
        var fileContent = try readRelativeFile(alloc, filename);
        defer alloc.free(fileContent);
        try stdout.print("Contents: \n{s}", .{fileContent});
    }
    else {
        _ = std.io.getStdOut().write("Usage: radiant [source]") catch return;
    }

    try bw.flush();
}

fn readRelativeFile(alloc: std.mem.Allocator, relFilename: []const u8) ![]u8 {
    var absPath = try std.fs.cwd().realpathAlloc(alloc, relFilename);
    defer alloc.free(absPath);
    var file = try std.fs.openFileAbsolute(absPath, std.fs.File.OpenFlags{});
    defer file.close();
    var fileBuff = try file.readToEndAlloc(alloc, 268435456);
    return fileBuff;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
