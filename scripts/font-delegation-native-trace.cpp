// Compare Text's internal Shape with the same path drawn through public Shape.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgText.h"
#include "tvgSwRenderer.cpp"

int main(int argc, char**)
{
    constexpr unsigned width = 96, height = 48;
    const float x = argc > 1 ? 8.5f : 5.0f;
    assert(Initializer::init(0) == Result::Success);
    assert(Text::load("thorvg/test/resources/PublicSans-Regular.ttf") == Result::Success);
    {
        std::vector<uint32_t> pixels(width * height, 0), direct(width * height, 0);
        auto canvas = SwCanvas::gen();
        assert(canvas->target(pixels.data(), width, width, height, ColorSpace::ABGR8888) == Result::Success);
        auto text = Text::gen();
        assert(text->font("PublicSans-Regular") == Result::Success);
        assert(text->size(24) == Result::Success);
        assert(text->text("ABC") == Result::Success);
        assert(text->fill(32, 32, 32) == Result::Success);
        assert(text->translate(x, 4) == Result::Success);
        auto impl = static_cast<TextImpl*>(text);
        const auto ownedShape = impl->shape;
        assert(canvas->add(text) == Result::Success);
        assert(canvas->update() == Result::Success);
        auto shape = static_cast<ShapeImpl*>(ownedShape);
        auto task = static_cast<SwShapeTask*>(shape->impl.rd);
        assert(task && task->rshape == &shape->rs);
        assert(!impl->impl.rd && impl->shape == ownedShape);
        for (auto pixel : pixels) assert(pixel == 0);
        assert(canvas->draw(true) == Result::Success);
        assert(shape->impl.rd == task && impl->shape == ownedShape);
        assert(task->shape.rle && task->shape.rle->size() > 0);

        auto other = SwCanvas::gen();
        assert(other->target(direct.data(), width, width, height, ColorSpace::ABGR8888) == Result::Success);
        auto ordinary = Shape::gen();
        const auto& path = shape->rs.path;
        assert(ordinary->appendPath(path.cmds.data, path.cmds.count, path.pts.data, path.pts.count) == Result::Success);
        assert(ordinary->transform(task->transform) == Result::Success);
        assert(ordinary->fill(32, 32, 32) == Result::Success);
        assert(other->add(ordinary) == Result::Success);
        assert(other->draw(true) == Result::Success);
        assert(other->sync() == Result::Success);
        assert(pixels == direct);

        std::printf("{\"width\":%u,\"height\":%u,\"x\":%g,\"commands\":%u,\"points\":%u,\"spans\":[", width, height, x, path.cmds.count, path.pts.count);
        const auto rle = task->shape.rle;
        for (unsigned i = 0; i < rle->size(); ++i) {
            const auto& s = rle->data()[i];
            std::printf("%s[%d,%d,%d,%u]", i ? "," : "", s.x, s.y, s.len, s.coverage);
        }
        std::printf("],\"pixels\":[");
        for (unsigned i = 0; i < pixels.size(); ++i) std::printf("%s%u", i ? "," : "", pixels[i]);
        std::printf("]}\n");
        assert(canvas->sync() == Result::Success);
        delete other;
        delete canvas;
    }
    assert(Text::unload("thorvg/test/resources/PublicSans-Regular.ttf") == Result::Success);
    assert(Initializer::term() == Result::Success);
}
