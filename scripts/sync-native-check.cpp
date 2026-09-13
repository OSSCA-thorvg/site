// Verify the article against the local engine without modifying its sources.
// Include the original CPU translation unit to inspect retained RenderData.
#include <cassert>
#include <cstdio>
#include <memory>
#include <vector>
#include "tvgCanvas.h"
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"

static void check(unsigned threads)
{
    assert(Initializer::init(threads) == Result::Success);
    {
        std::vector<uint32_t> pixels(32 * 32, 0);
        auto canvas = std::unique_ptr<SwCanvas>(SwCanvas::gen());
        assert(canvas->target(pixels.data(), 32, 32, 32, ColorSpace::ABGR8888S) == Result::Success);
        assert(canvas->sync() == Result::Success);

        auto shape = Shape::gen();
        shape->moveTo(7, 5);
        shape->lineTo(3, 19);
        shape->lineTo(18, 19);
        shape->close();
        shape->fill(230, 97, 33, 128);
        assert(canvas->add(shape) == Result::Success);
        assert(canvas->update() == Result::Success);
        auto renderer = static_cast<SwRenderer*>(canvas->pImpl->renderer);
        auto task = static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(shape)->impl.rd);
        assert(renderer->tasks.count == 1 && task->pushed);
        assert(canvas->draw(true) == Result::Success);
        assert(canvas->pImpl->status == Status::Drawing && !task->pending);
        assert(task->shape.rle && task->shape.rle->size() > 0);
        const auto rle = task->shape.rle;
        const auto drawn = pixels;
        const auto capacity = renderer->tasks.reserved;
        assert(canvas->update() == Result::InsufficientCondition);

        assert(canvas->sync() == Result::Success);
        assert(canvas->pImpl->status == Status::Synced);
        assert(renderer->tasks.count == 0 && renderer->tasks.reserved == capacity);
        assert(!task->pushed && !task->pending);
        assert(static_cast<ShapeImpl*>(shape)->impl.rd == task && task->shape.rle == rle);
        assert(pixels == drawn);
        assert(TaskScheduler::threads() == threads);
        assert(canvas->sync() == Result::Success);

        // Update without Draw still registers the reused task; Sync finishes it.
        assert(shape->translate(1, 2) == Result::Success);
        assert(canvas->update() == Result::Success);
        assert(static_cast<ShapeImpl*>(shape)->impl.rd == task);
        assert(renderer->tasks.count == 1 && task->pushed);
        assert(canvas->sync() == Result::Success);
        assert(renderer->tasks.count == 0 && !task->pushed && !task->pending);
        assert(canvas->pImpl->status == Status::Synced && pixels == drawn);

        // Removing an updated Paint defers its registered task's destruction.
        assert(shape->translate(2, 1) == Result::Success);
        assert(canvas->update() == Result::Success);
        assert(canvas->remove(shape) == Result::Success);
        assert(renderer->tasks.count == 1 && task->disposed && task->pushed);
        assert(canvas->sync() == Result::Success);
        // task has been deleted: do not dereference it after this boundary.
        assert(renderer->tasks.count == 0 && canvas->pImpl->status == Status::Synced);
        assert(pixels == drawn);
        std::printf("threads=%u: Draw/Sync, retained RLE, Update/Sync, deferred disposal, repeated Sync passed\n", threads);
    }
    assert(Initializer::term() == Result::Success);
}

int main()
{
    check(0);
    check(2);
}
