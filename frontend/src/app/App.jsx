import { Route, Routes } from 'react-router-dom';
import Header from '../components/layout/Header.jsx';
import ComingSoon from '../components/common/ComingSoon.jsx';
import OverviewPage from './overview/OverviewPage.jsx';
import { ROUTES } from '../constants/navigation.js';

// App shell: header + one route per screen. Each screen lives in its own folder under src/app.
export default function App() {
  return (
    <>
      <Header />
      <main>
        <Routes>
          <Route path={ROUTES.OVERVIEW} element={<OverviewPage />} />
          <Route path={ROUTES.MACHINE_LINES} element={<ComingSoon title="Machine lines" step={3} />} />
          <Route path={ROUTES.UPLOADS} element={<ComingSoon title="Uploads" step={4} />} />
          <Route path={ROUTES.WEEK_PLAN} element={<ComingSoon title="Week plan" step={7} />} />
          <Route path={ROUTES.DAY_PLAN} element={<ComingSoon title="Day plan" step={7} />} />
          <Route path="*" element={<ComingSoon title="Page not found" />} />
        </Routes>
      </main>
    </>
  );
}
