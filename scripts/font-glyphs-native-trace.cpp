// Read the actual Text Shape and replay the original, unmodified _build().
#include <cassert>
#include <cmath>
#include <cstdio>
#include <cstring>
#include "tvgText.h"
#include "tvgSfntLoader.cpp"

static void path(const RenderPath& value)
{
    std::printf("{\"cmds\":[");
    for (unsigned i = 0; i < value.cmds.count; ++i) {
        const auto cmd = value.cmds[i];
        const char* name = cmd == PathCommand::MoveTo ? "M" : cmd == PathCommand::LineTo ? "L" : cmd == PathCommand::CubicTo ? "C" : "Z";
        assert(cmd == PathCommand::MoveTo || cmd == PathCommand::LineTo || cmd == PathCommand::CubicTo || cmd == PathCommand::Close);
        std::printf("%s\"%s\"", i ? "," : "", name);
    }
    std::printf("],\"pts\":[");
    for (unsigned i = 0; i < value.pts.count; ++i) std::printf("%s[%.9g,%.9g]", i ? "," : "", value.pts[i].x, value.pts[i].y);
    std::printf("]}");
}

int main(int argc, char** argv)
{
    assert(argc >= 2);
    const char* word = argc > 2 ? argv[2] : "ABC";
    assert(Initializer::init(0) == Result::Success);
    assert(Text::load(argv[1]) == Result::Success);
    auto text = Text::gen();
    assert(text->font("PublicSans-Regular") == Result::Success);
    assert(text->size(100) == Result::Success);
    assert(text->text(word) == Result::Success);
    auto impl = static_cast<TextImpl*>(text);
    assert(impl->load());
    auto loader = static_cast<SfntLoader*>(impl->loader);
    const auto& actual = static_cast<ShapeImpl*>(impl->shape)->rs.path;
    RenderPath replay;
    Point cursor{};
    SfntGlyphMetrics* previous = nullptr;
    std::printf("{\"text\":\"%s\",\"unitsPerEm\":%u,\"glyphs\":[", word, unsigned(loader->reader->metrics.unitsPerEm));
    for (unsigned i = 0; i < std::strlen(word); ++i) {
        assert(word[i] >= 'A' && word[i] <= 'Z');
        auto glyph = loader->request(word[i]);
        assert(glyph);
        Point offset{};
        if (previous) loader->reader->positioning(previous->idx, glyph->idx, offset);
        const auto cmdBegin = replay.cmds.count, pointBegin = replay.pts.count;
        _build(glyph->path, cursor, offset, replay);
        std::printf("%s{\"letter\":\"%c\",\"advance\":%.9g,\"cursor\":[%.9g,%.9g],\"offset\":[%.9g,%.9g],\"cmdRange\":[%u,%u],\"pointRange\":[%u,%u],\"path\":", i ? "," : "", word[i], glyph->advance, cursor.x, cursor.y, offset.x, offset.y, cmdBegin, replay.cmds.count, pointBegin, replay.pts.count);
        path(glyph->path);
        cursor.x += (glyph->advance + offset.x) * impl->fm.spacing.x;
        std::printf(",\"nextCursor\":[%.9g,%.9g]}", cursor.x, cursor.y);
        previous = glyph;
        // Every appended prefix must equal the native Text's single Shape path.
        for (unsigned j = 0; j < replay.cmds.count; ++j) assert(replay.cmds[j] == actual.cmds[j]);
        for (unsigned j = 0; j < replay.pts.count; ++j) {
            assert(std::fabs(replay.pts[j].x - actual.pts[j].x) < 0.0001f);
            assert(std::fabs(replay.pts[j].y - actual.pts[j].y) < 0.0001f);
        }
    }
    assert(replay.cmds.count == actual.cmds.count && replay.pts.count == actual.pts.count);
    std::printf("],\"result\":");path(actual);std::printf("}\n");
    Paint::rel(text);
    assert(Text::unload(argv[1]) == Result::Success);
    assert(Initializer::term() == Result::Success);
}
