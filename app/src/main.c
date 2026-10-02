#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(demo, LOG_LEVEL_DBG);

#define STACK_SIZE 1024

#define PRIO_LOW        7
#define PRIO_MED        5
#define PRIO_HIGH       3

#define SLEEP_LOW_MS    300
#define SLEEP_MED_MS    200
#define SLEEP_HIGH_MS   100

void t_low_fn(void *p1, void *p2, void *p3)
{
    while (1) {
        LOG_DBG("%s running", __func__);
        k_msleep(SLEEP_LOW_MS);
    }
}

void t_med_fn(void *p1, void *p2, void *p3)
{
    while (1) {
        LOG_DBG("%s running", __func__);
        k_msleep(SLEEP_MED_MS);
    }
}

void t_high_fn(void *p1, void *p2, void *p3)
{
    while (1) {
        LOG_DBG("%s running", __func__);
        k_msleep(SLEEP_HIGH_MS);
    }
}

K_THREAD_DEFINE(t_low,  STACK_SIZE, t_low_fn,  NULL, NULL, NULL, PRIO_LOW,  0, 0);
K_THREAD_DEFINE(t_med,  STACK_SIZE, t_med_fn,  NULL, NULL, NULL, PRIO_MED,  0, 0);
K_THREAD_DEFINE(t_high, STACK_SIZE, t_high_fn, NULL, NULL, NULL, PRIO_HIGH, 0, 0);

int main(void)
{
    return 0;
}

