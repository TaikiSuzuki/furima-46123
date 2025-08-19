const priceCalc = () => {
  const priceInput = document.getElementById("item-price");
  if (!priceInput) return;

  priceInput.addEventListener('input', () => {
    // 入力された値を数値に変換
    const price = parseInt(priceInput.value, 10);
    
    if (!isNaN(price) && price >= 300 && price <= 9999999) {
      // 販売手数料（10%）を計算し、小数点以下を切り捨てる
      const fee = Math.floor(price * 0.1);
      
      const profit = price - fee;
      const feeElement = document.getElementById("add-tax-price");
      const profitElement = document.getElementById("profit");

      feeElement.innerHTML = fee.toLocaleString();
      profitElement.innerHTML = profit.toLocaleString();
    } else {
      // 価格が条件を満たさない場合、表示を空にする
      const feeElement = document.getElementById("add-tax-price");
      const profitElement = document.getElementById("profit");
      feeElement.innerHTML = '';
      profitElement.innerHTML = '';
    }
  });
};

document.addEventListener('turbo:load', priceCalc);