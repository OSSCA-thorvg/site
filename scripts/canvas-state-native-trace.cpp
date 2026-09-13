// Exercise the common Canvas::Impl status gates through public API calls.
// CPU supplies a runnable backend; the diagram describes the common Canvas code.
#include <cassert>
#include <cstdio>
#include "tvgCanvas.h"

const char* state(Status s)
{
    switch (s) {
        case Status::Synced: return "Synced";
        case Status::Painting: return "Painting";
        case Status::Updating: return "Updating";
        case Status::Drawing: return "Drawing";
        case Status::Damaged: return "Damaged";
    }
    return "invalid";
}

struct Fixture
{
    uint32_t pixels[64]{};
    SwCanvas* canvas = SwCanvas::gen();
    Shape* shape = nullptr;
    Status status() { return canvas->pImpl->status; }
    Result add()
    {
        auto p = Shape::gen();
        p->appendRect(1, 1, 4, 4); p->fill(32, 32, 32);
        auto ret = canvas->add(p);
        if (ret != Result::Success) Paint::rel(p);
        else if (!shape) shape = p;
        return ret;
    }
    Result call(const char* api)
    {
        if (!strcmp(api, "target")) return canvas->target(pixels, 8, 8, 8, ColorSpace::ABGR8888);
        if (!strcmp(api, "add")) return add();
        if (!strcmp(api, "remove")) { auto ret = canvas->remove(shape); if (ret == Result::Success) shape = nullptr; return ret; }
        if (!strcmp(api, "viewport")) return canvas->viewport(1, 1, 6, 6);
        if (!strcmp(api, "update")) return canvas->update();
        if (!strcmp(api, "draw")) return canvas->draw(true);
        return canvas->sync();
    }
    void ready(Status desired)
    {
        assert(call("target") == Result::Success);
        assert(call("add") == Result::Success);
        assert(call("draw") == Result::Success);
        assert(call("sync") == Result::Success);
        if (desired == Status::Painting) assert(call("add") == Result::Success);
        if (desired == Status::Damaged) assert(call("target") == Result::Success);
        if (desired == Status::Updating || desired == Status::Drawing) assert(call("update") == Result::Success);
        if (desired == Status::Drawing) assert(call("draw") == Result::Success);
        assert(status() == desired);
    }
    void emit(const char* api)
    {
        auto before = status();
        auto ret = call(api);
        assert(ret == Result::Success || ret == Result::InsufficientCondition);
        std::printf("{\"api\":\"%s\",\"before\":\"%s\",\"after\":\"%s\",\"result\":\"%s\"}", api, state(before), state(status()), ret == Result::Success ? "Success" : "InsufficientCondition");
    }
    ~Fixture() { canvas->sync(); delete canvas; }
};

int main()
{
    assert(Initializer::init(0) == Result::Success);
    std::printf("{\"matrix\":[");
    bool comma = false;
    for (auto s : {Status::Synced, Status::Painting, Status::Updating, Status::Drawing, Status::Damaged}) {
        for (auto api : {"update", "draw", "sync", "add", "remove", "target", "viewport"}) {
            Fixture f; f.ready(s);
            if (comma) std::printf(","); comma = true;
            f.emit(api);
        }
    }
    std::printf("],\"example\":[");
    {
        Fixture f;
        assert(f.status() == Status::Synced);
        bool comma = false;
        for (auto api : {"target", "add", "draw", "update", "sync"}) {
            if (comma) std::printf(","); comma = true;
            f.emit(api);
        }
    }
    {
        Fixture f; f.ready(Status::Synced);
        assert(f.canvas->viewport(0, 0, 8, 8) == Result::Success);
        assert(f.status() == Status::Synced);
    }
    std::printf("]}\n");
    assert(Initializer::term() == Result::Success);
}
