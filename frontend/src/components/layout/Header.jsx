import { NavLink } from 'react-router-dom';
import { NAV_TABS, ROUTES } from '../../constants/navigation.js';

export default function Header() {
  return (
    <header className="top">
      <div className="brand">
        Auto Plan <span>Week &amp; Day planning</span>
      </div>
      <nav>
        {NAV_TABS.map((tab) => (
          <NavLink key={tab.path} to={tab.path} end={tab.path === ROUTES.OVERVIEW}>
            {tab.label}
          </NavLink>
        ))}
      </nav>
    </header>
  );
}
