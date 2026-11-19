import { NavLink, Route, Routes } from 'react-router-dom';
import OverviewPage from './pages/OverviewPage.jsx';
import ComingSoon from './pages/ComingSoon.jsx';

const tabs = [
  { path: '/', label: 'Overview' },
  { path: '/machine-lines', label: 'Machine lines' },
  { path: '/uploads', label: 'Uploads' },
  { path: '/week-plan', label: 'Week plan' },
  { path: '/day-plan', label: 'Day plan' },
];

export default function App() {
  return (
    <>
      <header className="top">
        <div className="brand">
          Auto Plan <span>Week &amp; Day planning</span>
        </div>
        <nav>
          {tabs.map((t) => (
            <NavLink key={t.path} to={t.path} end={t.path === '/'}>
              {t.label}
            </NavLink>
          ))}
        </nav>
      </header>
      <main>
        <Routes>
          <Route path="/" element={<OverviewPage />} />
          <Route path="/machine-lines" element={<ComingSoon title="Machine lines" step={3} />} />
          <Route path="/uploads" element={<ComingSoon title="Uploads" step={4} />} />
          <Route path="/week-plan" element={<ComingSoon title="Week plan" step={7} />} />
          <Route path="/day-plan" element={<ComingSoon title="Day plan" step={7} />} />
          <Route path="*" element={<ComingSoon title="Page not found" />} />
        </Routes>
      </main>
    </>
  );
}
