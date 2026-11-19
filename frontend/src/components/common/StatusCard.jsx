// Small card with a coloured status value and a label underneath.
export default function StatusCard({ label, ok, text }) {
  return (
    <div className="card">
      <b className={ok ? 'ok' : 'bad'}>{text}</b>
      <span>{label}</span>
    </div>
  );
}
