const x = document.getElementById('Email');
const y = document.getElementById('text-muted f-w-400');
const btn = document.querySelector('Вход');
btn.onclick = () => {
  y.value = x.value;
  x.value = "";
}
<div>
  <textarea id="fffff"></textarea>
  <textarea id="txt2"></textarea>
  <button>translate</button>
</div>