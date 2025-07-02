
# Dark👣 Systems | M365 Tenant-to-Tenant Migration Toolkit

This toolkit contains everything needed to simulate and execute a Microsoft 365 tenant-to-tenant migration. Built for freelancers, IT professionals, and systems engineers.

---

## 🔗 What's Included

### Folders:
- **Scripts/**
  - `ExportList.ps1` — Export SharePoint List from Source
  - `ImportList.ps1` — Import SharePoint List to Target
- **Sample Data/**
  - `ClientDirectory.csv` — Original list export
  - `ClientDirectory_CLEAN.csv` — Cleaned import version
- **Screenshots/**
  - Full visual documentation of every migration step
- **Reports/**
  - `M365_Migration_CaseStudy.pdf`
  - `Checklist_M365_Migration.pdf`
- **PST Exports/** (optional for demo purposes)
  - Example `.pst` files used for mailbox/contact migration

---

## ✅ Migration Tasks Covered

| Task                        | Method             | Status |
|-----------------------------|--------------------|--------|
| Tenant Creation             | Manual             | ✅     |
| User Creation               | Manual             | ✅     |
| OneDrive File Migration     | Script + GUI       | ✅     |
| SharePoint Site Creation    | Manual             | ✅     |
| SharePoint File Upload      | PnP Script         | ✅     |
| SharePoint List Migration   | Script + GUI       | ✅     |
| Mailbox Migration           | PST Export/Import  | ✅     |
| Contact/Calendar Migration  | PST Bundle         | ✅     |

---

## 🚀 Use Cases

- Freelancers offering M365 migration services
- IT pros preparing for Microsoft 365 certifications
- Consultants simulating real-world migrations
- Students building project portfolios

---

## 🛠️ Requirements

- PowerShell 5.1+
- PnP PowerShell Module
- Microsoft 365 Trial Tenants (2)
- Outlook (for PST work)

---

## 📇 Project Author

**Ayobamidele Aderosoye**  
Systems Engineer & Automation Architect  
[GitHub: Aderosoye](https://github.com/Aderosoye)  
Website: [aderosoye.github.io/dark-systems](https://aderosoye.github.io/dark-systems)
