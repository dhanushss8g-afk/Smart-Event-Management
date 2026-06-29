# Smart Event Registration + Attendance System - Implementation Plan

This plan details the design, architecture, and development steps for the **Smart Event Registration + Attendance System**. Since Node.js/npm is not globally installed in the target workspace, the first step involves downloading a portable Node.js runtime to build and run the Vite React application.

---

## User Review Required

> [!IMPORTANT]
> **Local Node.js Setup**: We will download and extract Node.js v20.11.1 (64-bit Windows) into a `.bin` folder inside the workspace. This will allow us to run `npm` and `npx` commands.
> 
> **Database & Backend Architecture**: To deliver a fully functional and testable system without requiring complex local database installations (like MongoDB) and server hosting, the application will use a client-side database model powered by `localStorage`. This will persist events, registrations, attendance, and certificate data locally on the user's browser, providing a zero-dependency setup.
> 
> **Tailwind CSS vs. Vanilla CSS**: Following our design guidelines, we will use **Vanilla CSS** to construct a custom, modern, glassmorphic dark-themed design system, avoiding Tailwind CSS unless explicitly requested.

---

## Open Questions

> [!NOTE]
> None at the moment. The PRD is detailed and complete. If you have any specific styling or branding preferences (e.g., specific college colors), please share! Otherwise, we will proceed with a premium deep-space dark theme with purple and indigo glow effects to complement the `<DotField />` component.

---

## Proposed Changes

### Component: Environment Setup

#### [NEW] [setup_env.ps1](file:///c:/Users/user/Desktop/smart%20event%20management/setup_env.ps1)
A PowerShell script that will:
1. Create a `.node_env` directory in the project root.
2. Download Node.js v20.11.1 Windows binary zip.
3. Extract it into `.node_env`.
4. Create shortcut wrappers `npm.ps1` and `npx.ps1` in the project root to run using the downloaded Node executable, making it easy to run project commands.

---

### Component: Frontend Scaffold

#### [NEW] [package.json](file:///c:/Users/user/Desktop/smart%20event%20management/package.json)
Standard npm package configuration defining dependencies:
- React 18, React DOM 18
- React Router DOM (for page routing)
- Lucide React (for premium iconography)
- Canvas Confetti (for registration & check-in celebrations)
- QRCode Generator / HTML5-QRCode (for generation and scanning)
- jsPDF (for client-side PDF generation)

#### [NEW] [vite.config.js](file:///c:/Users/user/Desktop/smart%20event%20management/vite.config.js)
Vite configuration for building and running the development server.

#### [NEW] [index.html](file:///c:/Users/user/Desktop/smart%20event%20management/index.html)
Root HTML file including Google Fonts (Inter / Space Grotesk) and target div for React mounting.

#### [NEW] [src/index.css](file:///c:/Users/user/Desktop/smart%20event%20management/src/index.css)
Core CSS design system containing global variables (theme colors, glow values, spacing), glassmorphism classes, animations, and typography configurations.

---

### Component: React Components & Pages

#### [NEW] [src/components/DotField.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/components/DotField.jsx)
The custom `<DotField />` canvas-based background effect from React Bits, integrated with its corresponding CSS:
- [src/components/DotField.css](file:///c:/Users/user/Desktop/smart%20event%20management/src/components/DotField.css)

#### [NEW] [src/utils/db.js](file:///c:/Users/user/Desktop/smart%20event%20management/src/utils/db.js)
A robust `localStorage` wrapper acting as our mock database for Users, Events, Registrations, Attendance, and Certificates, prepopulated with realistic mock events and users.

#### [NEW] [src/components/Navbar.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/components/Navbar.jsx)
Responsive navigation header supporting student/admin view toggle, profile menus, and login/logout state triggers.

#### [NEW] [src/pages/Home.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/pages/Home.jsx)
The landing page containing:
- Hero section overlaying the `<DotField />` particle system.
- Feature grid (highlights: registration, check-in, certificates).
- Dynamic list of upcoming events.

#### [NEW] [src/pages/Events.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/pages/Events.jsx)
Catalog of active events. Features search filtering, calendar sorting, and detail modals showing venue, times, and registration status.

#### [NEW] [src/pages/Registration.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/pages/Registration.jsx)
Student registration page containing the validation form, duplicate checks, and registration limits handling.

#### [NEW] [src/pages/Attendance.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/pages/Attendance.jsx)
Check-in dashboard. Supports:
1. Scanning a QR code (using client camera / mock scanning file uploads).
2. Entering the event's unique 6-digit check-in code.
3. Live verification of student identity, registration records, and success toast check-in notifications.

#### [NEW] [src/pages/Certificate.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/pages/Certificate.jsx)
Renders a high-fidelity vector certificate preview (using canvas/SVG structure) featuring Student Name, Event Name, Date, Organizer Signature, and Unique Certificate ID. Includes functionality to download the certificate as a PDF via `jsPDF`.

#### [NEW] [src/pages/AdminDashboard.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/pages/AdminDashboard.jsx)
Admin-only page containing:
- Stat cards (Total Events, Total Registered, Present count, Certificates generated).
- Event Management drawer (Create/Edit/Delete events).
- Live Participant Table with search, department filtering, and manually triggerable "Mark Present" status toggle.
- "Export CSV" feature to immediately save participant logs.

#### [NEW] [src/App.jsx](file:///c:/Users/user/Desktop/smart%20event%20management/src/App.jsx)
Root React router orchestration, coordinating context-based state (auth, db data) and modal popups.

---

## Verification Plan

### Automated Tests
Once the workspace dependencies are installed, we will verify the code compiles and starts successfully:
- Launch server: `.\npm.ps1 run dev`
- Build verify: `.\npm.ps1 run build`

### Manual Verification
We will use the **browser subagent** to perform a complete end-to-end user flow:
1. Open the application landing page.
2. Select an event and complete the student registration form.
3. Verify the registration record shows up in the database.
4. Access the Attendance page, enter the unique event code to check in.
5. Navigate to the Certificate page and verify the certificate is correctly generated and downloadable.
6. Log in as an Admin, inspect the analytics numbers, create a new event, toggle a user's attendance status, and test exporting the CSV.
