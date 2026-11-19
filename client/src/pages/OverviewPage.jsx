import { useEffect, useState } from 'react';
import { api } from '../api.js';

export default function OverviewPage() {
  const [health, setHealth] = useState(null);
  const [error, setError] = useState('');

  async function check() {
    setError('');
    try {
      setHealth(await api('/health'));
    } catch (err) {
      setHealth(null);
      setError(err.message);
    }
  }

  useEffect(() => {
    check();
  }, []);

  const apiOk = health?.api === 'ok';
  const dbOk = health?.database === 'connected';

  return (
    <section>
      <div className="row between">
        <h1>Overview</h1>
        <button className="ghost" onClick={check}>Check again</button>
      </div>

      <div className="cards">
        <Status label="API server" ok={apiOk} text={apiOk ? 'Running' : 'Not reachable'} />
        <Status label="PostgreSQL" ok={dbOk} text={dbOk ? 'Connected' : health ? 'Not connected' : '—'} />
      </div>

      {error && (
        <div className="panel bad">
          API not reachable: {error}. Is the server running (npm run dev)?
        </div>
      )}
      {health && !dbOk && (
        <div className="panel bad">
          Database: {health.databaseError}
          <div className="small muted">Check DATABASE_URL in server/.env, then run npm run db:push.</div>
        </div>
      )}

      <div className="panel">
        <h2>How a week is planned</h2>
        <ol className="steps">
          <li><b>Friday 05:00</b>: week plan for 1 production week + 4 packing-material weeks.</li>
          <li>Each order is planned one week before its ship date, the whole order in one week (at most spilling into the next).</li>
          <li>An order is planned only if every SKU has material; machine-line capacity is used at 100%.</li>
          <li><b>Monday</b>: day plan for 12 shifts (Mon A to Sat B) per machine line and machine.</li>
          <li>Unproduced quantity carries to the next shift without a new material requisition.</li>
        </ol>
      </div>
    </section>
  );
}

function Status({ label, ok, text }) {
  return (
    <div className="card">
      <b className={ok ? 'ok' : 'bad'}>{text}</b>
      <span>{label}</span>
    </div>
  );
}
