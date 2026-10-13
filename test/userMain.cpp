// Test selection: the Makefile defines exactly one TEST_* macro from
// `make qemu TEST=<name>` (default: full). See README for what each test does.

#if defined(TEST_THREADS_C)
#include "../test/Threads_C_API_test.hpp" // threads, C API, synchronous context switch
#elif defined(TEST_THREADS_CPP)
#include "../test/Threads_CPP_API_test.hpp" // threads, C++ API, synchronous context switch
#elif defined(TEST_SYNC_C)
#include "../test/ConsumerProducer_C_API_test.h" // full C API with semaphores, synchronous context switch
#elif defined(TEST_SYNC_CPP)
#include "../test/ConsumerProducer_CPP_Sync_API_test.hpp" // full C++ API with semaphores, synchronous context switch
#elif defined(TEST_SLEEP)
#include "../test/ThreadSleep_C_API_test.hpp" // time_sleep, C API
#elif defined(TEST_FULL)
#include "../test/ConsumerProducer_CPP_API_test.hpp" // C++ API + preemption, test of everything
#else
#error "No test selected, build with: make TEST=<threads-c|threads-cpp|sync-c|sync-cpp|sleep|full>"
#endif

void userMain() {
#if defined(TEST_THREADS_C)
    Threads_C_API_test();
#elif defined(TEST_THREADS_CPP)
    Threads_CPP_API_test();
#elif defined(TEST_SYNC_C)
    producerConsumer_C_API();
#elif defined(TEST_SYNC_CPP)
    producerConsumer_CPP_Sync_API();
#elif defined(TEST_SLEEP)
    testSleeping();
#elif defined(TEST_FULL)
    ConsumerProducerCPP::testConsumerProducer();
#endif
}
