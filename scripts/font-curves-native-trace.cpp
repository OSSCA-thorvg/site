// Read raw TTF points/flags and the unmodified TtfReader::convert() output.
#include <cassert>
#include <cstdio>
#include <fstream>
#include <iterator>
#include <vector>
#include "tvgTtfReader.h"

int main(int argc, char** argv)
{
    const unsigned codepoint = argc > 1 ? unsigned(argv[1][0]) : 'B';
    std::ifstream file("thorvg/test/resources/PublicSans-Regular.ttf", std::ios::binary);
    std::vector<uint8_t> bytes((std::istreambuf_iterator<char>(file)), {});
    assert(!bytes.empty());
    TtfReader reader(bytes.data(), bytes.size());
    assert(reader.header() == Result::Success);
    SfntGlyph glyph{};
    RenderPath path;
    assert(reader.convert(glyph, codepoint, path));
    const auto start = reader.outlineOffset(glyph.idx);
    const auto count = reader.i16(start);
    assert(count > 0);  // This fixture uses simple glyphs, not composites.
    auto outline = start + 10;
    std::vector<uint16_t> ends(count);
    for (auto& end : ends) { end = reader.u16(outline); outline += 2; }
    outline += 2 + reader.u16(outline);
    std::vector<uint8_t> flags(ends.back() + 1);
    std::vector<Point> points(flags.size());
    assert(reader.flags(&outline, flags.data(), flags.size()));
    assert(reader.points(outline, flags.data(), points.data(), points.size(), {}));
    std::printf("{\"letter\":\"%c\",\"ends\":[", codepoint);
    for (unsigned i = 0; i < ends.size(); ++i) std::printf("%s%u", i ? "," : "", ends[i]);
    std::printf("],\"raw\":[");
    for (unsigned i = 0; i < points.size(); ++i) std::printf("%s{\"point\":[%.9g,%.9g],\"on\":%s}", i ? "," : "", points[i].x, points[i].y, flags[i] & 1 ? "true" : "false");
    std::printf("],\"path\":{\"cmds\":[");
    for (unsigned i = 0; i < path.cmds.count; ++i) {
        const auto cmd = path.cmds[i];
        const char* name = cmd == PathCommand::MoveTo ? "M" : cmd == PathCommand::LineTo ? "L" : cmd == PathCommand::CubicTo ? "C" : "Z";
        std::printf("%s\"%s\"", i ? "," : "", name);
    }
    std::printf("],\"pts\":[");
    for (unsigned i = 0; i < path.pts.count; ++i) std::printf("%s[%.9g,%.9g]", i ? "," : "", path.pts[i].x, path.pts[i].y);
    std::printf("]}}\n");
}
