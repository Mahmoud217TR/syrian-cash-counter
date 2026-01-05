<script setup lang="ts">
  import { computed, ref } from 'vue'
  import { type Bill, generateBill } from './bill'

  const totalValue = computed(() => {
    let total = 0;
    for (const bill of bills) {
      const count = billCounts.value[bill.id] || 0;
      total += bill.value * count;
    }
    return total;
  });

  const newPrice = computed(() => {
    return totalValue.value / 100;
  });

  const formatNumber = (num: number) => {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  const formattedTotalValue = computed(() => {
    return formatNumber(totalValue.value);
  });
  const formattedNewPrice = computed(() => {
    return formatNumber(newPrice.value);
  });

  const bills: Bill[] = [
    generateBill(1, 50000, '500 ل.س', true, 'images/bills/new/500.png'),
    generateBill(2, 20000, '200 ل.س', true, 'images/bills/new/200.png'),
    generateBill(3, 10000, '100 ل.س', true, '/images/bills/new/100.png'),
    generateBill(4, 5000, '50 ل.س', true, 'images/bills/new/50.png'),
    generateBill(5, 2500, '25 ل.س', true, '/images/bills/new/25.png'),
    generateBill(6, 1000, '10 ل.س', true, 'images/bills/new/10.png'),
    generateBill(7, 5000, '5,000 ل.س', false, 'images/bills/old/5000.png'),
    generateBill(8, 2000, '2,000 ل.س', false, 'images/bills/old/2000.png'),
    generateBill(9, 1000, '1,000 ل.س', false, 'images/bills/old/1000.png'),
    generateBill(10, 500, '500 ل.س', false, 'images/bills/old/500.png'),
  ]

  const billCounts = ref<Record<number, number>>(
    Object.fromEntries(bills.map((bill) => [bill.id, 0]))
  );

  const normalizeCount = (billId: number) => {
    const nextValue = Number(billCounts.value[billId] || 0);
    billCounts.value[billId] = Math.max(0, Math.floor(nextValue));
  };

  const incrementCount = (billId: number) => {
    billCounts.value[billId] = (billCounts.value[billId] || 0) + 1;
  };

  const decrementCount = (billId: number) => {
    billCounts.value[billId] = Math.max(0, (billCounts.value[billId] || 0) - 1);
  };
</script>

<template>
  <div class="relative min-h-screen overflow-hidden bg-[#151520] text-white">
    <div class="pointer-events-none absolute -left-24 -top-24 h-72 w-72 rounded-full bg-indigo-500/20 blur-3xl"></div>
    <div class="pointer-events-none absolute -bottom-28 right-0 h-96 w-96 rounded-full bg-rose-500/10 blur-3xl"></div>
    <div class="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top,_#1c1c2b_0%,_#14141f_45%,_#101018_100%)] opacity-90"></div>

    <main class="relative z-10 mx-auto flex min-h-screen max-w-6xl flex-col gap-10 px-6 py-12">
      <header class="flex flex-col items-center gap-3 text-center">
        <span class="text-xs uppercase tracking-[0.4em] text-white/50">Syrian Cash Counter</span>
        <h1 class="text-3xl font-semibold md:text-4xl">
          حاسبة العملة السورية
        </h1>
        <p class="max-w-xl text-sm text-white/60">
          أدخل عدد الأوراق النقدية لتحصل على القيمة الإجمالية والحساب بالسعر الجديد.
        </p>
      </header>

      <section class="grid gap-8">
        <div class="flex flex-col gap-6 rounded-[36px] border border-white/10 bg-gradient-to-b from-[#232438] via-[#1b1d2f] to-[#121323] p-6 shadow-[0_25px_60px_rgba(7,9,18,0.65)]">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold">مجموع القطع</h2>
          </div>

          <div class="mt-4 rounded-3xl border border-white/10 bg-gradient-to-b from-white/10 to-transparent p-6">
            <p class="text-xs uppercase tracking-[0.35em] text-white/50 mb-4">القيمة على السعر القديم</p>
            <p class="mt-3 text-4xl font-semibold md:text-5xl">{{ formattedTotalValue }}</p>
            <p class="mt-3 text-sm text-white/60">القيمة على السعر الجديد</p>
            <p class="mt-1 text-2xl font-semibold text-white/80">{{ formattedNewPrice }}</p>
          </div>
        </div>
        <div class="rounded-[36px] border border-white/10 bg-gradient-to-b from-[#24263a] via-[#1c1f31] to-[#15172a] p-6 shadow-[0_25px_60px_rgba(7,9,18,0.65)]">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold">عدد الأوراق</h2>
          </div>

          <div class="mt-6 space-y-4">
            <div
              v-for="bill in bills"
              :key="bill.id"
              class="rounded-2xl border border-white/5 bg-white/5 p-4 shadow-[inset_0_0_20px_rgba(255,255,255,0.02)]"
            >
              <div class="flex items-center justify-between gap-4">
                <div class="flex flex-col items-center md:flex-row gap-4">
                  <label
                    :for="'bill-' + bill.id"
                    class="flex h-24 md:w-40 aspect-square items-center justify-center rounded-2xl"
                  >
                    <img :src="bill.image" :alt="bill.label" class="h-12 md:h-auto w-auto object-contain">
                  </label>
                  <div class="flex-1">
                    <p class="text-sm font-semibold md:mb-2">{{ bill.label }}</p>
                    <bdi class="text-xs text-white/50">
                      {{ formatNumber(bill.value) }} لكل قطعة
                    </bdi>
                  </div>
                </div>
                <div class="flex items-center gap-2 flex-col md:flex-row">
                  <input
                    :id="'bill-' + bill.id"
                    type="number"
                    min="0"
                    class="h-10 w-20 rounded-full border border-white/10 bg-[#11131f] text-center text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400/40"
                    v-model.number="billCounts[bill.id]"
                    @blur="normalizeCount(bill.id)"
                  >
                  <div class="flex items-center gap-2">
                      <button
                        class="h-9 w-9 rounded-full border border-white/10 bg-white/5 text-lg text-white/80 cursor-pointer"
                        type="button"
                        @click="decrementCount(bill.id)"
                      >
                      -
                    </button>
                    <button
                      class="h-9 w-9 rounded-full border border-white/10 bg-white/5 text-lg text-white/80 cursor-pointer"
                      type="button"
                      @click="incrementCount(bill.id)"
                    >
                      +
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="mt-10 relative z-10 container mx-auto">
      <hr class="text-white/60 mb-4">
      <div class="flex items-center flex-col md:flex-row justify-between gap-4">
        <p class="text-center text-white/60 mb-6">
          تم الإنشاء بواسطة
          <a
            href="https://mahmoudtr.com"
            target="_blank"
            rel="noopener noreferrer"
            class="hover:text-white"
          >
            MahmoudTR
          </a>
        </p>
        <p class="text-center text-white/60 mb-6">
          2026 © جميع الحقوق محفوظة.
        </p>
      </div>
    </footer>
  </div>
</template>

<style scoped>

</style>
