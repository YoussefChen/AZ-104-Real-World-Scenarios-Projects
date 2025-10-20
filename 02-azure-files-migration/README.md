# Azure Files Migration Project

Complete enterprise file server migration from on-premises to Azure Files with sync, backup, and lifecycle management.

## 🎯 Project Objectives

- Migrate 2TB file server to Azure Files
- Maintain user access with same drive mappings
- Implement cloud tiering (80% free space policy)
- Configure automated backups with 30-day retention
- Secure storage with network isolation
- Automate lifecycle management for cost optimization

## 🏗️ Architecture
```
On-Premises Server (Simulated)                Azure Cloud
┌────────────────────────┐
│  Windows Server 2022   │              ┌─────────────────────────┐
│  ┌──────────────────┐  │              │  Azure Files Premium    │
│  │  F:\CompanyData  │  │◄────Sync────►│  companydata-share      │
│  │  - HR/           │  │              │  100 GiB provisioned    │
│  │  - Finance/      │  │              └──────────┬──────────────┘
│  │  - IT/           │  │                         │
│  │  - Sales/        │  │              ┌──────────▼──────────────┐
│  └──────────────────┘  │              │  Azure File Sync        │
│  Cloud Tiering: 80%    │              │  - Server Endpoint      │
│  Free Space            │              │  - Cloud Tiering        │
└────────────────────────┘              └─────────────────────────┘
                                                   │
                                        ┌──────────▼──────────────┐
                                        │  Recovery Services Vault│
                                        │  - Daily Backups        │
                                        │  - 30-day Retention     │
                                        └─────────────────────────┘
```

## 🛠️ Technologies Used

- **Azure Files Premium** - High-performance SMB file shares
- **Azure File Sync** - Hybrid sync solution
- **Recovery Services Vault** - Azure Backup
- **Lifecycle Management** - Cool tier automation
- **Storage Firewall** - Network security
- **PowerShell** - Automation scripts

## 📋 Prerequisites

- Azure subscription
- Azure PowerShell module
- Windows Server 2022 (or VM)
- RDP client
- Basic networking knowledge

## 🚀 Deployment Steps

### Phase 1: On-Premises Setup
1. Create Windows Server VM (simulated on-prem)
2. Configure data disk and file shares
3. Create sample data structure
4. Set NTFS permissions

### Phase 2: Azure Infrastructure
1. Create Premium Storage Account
2. Deploy Azure File Share (100 GiB)
3. Configure network isolation
4. Enable soft delete

### Phase 3: Azure File Sync
1. Deploy Storage Sync Service
2. Create sync group
3. Install sync agent on server
4. Register server endpoint
5. Configure cloud tiering (80% policy)

### Phase 4: Backup Configuration
1. Create Recovery Services Vault
2. Configure backup policy (daily, 30-day retention)
3. Enable backup for file share
4. Test restore functionality

### Phase 5: Lifecycle Management
1. Create policy to move files to Cool tier after 90 days
2. Configure retention rules

## 📊 Key Features Implemented

### Cloud Tiering
- **Policy**: Keep 80% volume free space
- **Date Policy**: Tier files not accessed in 30 days
- **Result**: Reduces on-prem storage needs by ~75%

### Backup Strategy
- **Frequency**: Daily at 2:00 AM
- **Retention**: 30 days
- **Instant Restore**: 2-day snapshot retention
- **RTO**: < 15 minutes

### Security
- Network isolation (VNet integration)
- Storage firewall configured
- TLS 1.2 enforced
- NTFS permission sync

### Cost Optimization
- Lifecycle policy: Cool tier after 90 days
- Right-sized provisioning (100 GiB)
- Auto-shutdown for test VMs
- Monitoring alerts for unusual usage

## 📁 Project Structure
```
Project-02-Azure-Files-Migration/
├── Screenshots/
│   ├── 01-resource-group-created.png
│   ├── 02-vnet-created.png
│   ├── ...
│   └── 35-monitoring-dashboard.png
├── Scripts/
│   ├── 01-Setup-OnPremFileServer.ps1
│   ├── 02-Create-AzureFiles-Infrastructure.ps1
│   ├── 03-Test-FileSync.ps1
│   ├── 04-Monitor-CloudTiering.ps1
│   ├── 05-Verify-Backup.ps1
└── README.md
```

## 🧪 Testing Performed

1. **Sync Testing**
   - Created test files on server
   - Verified sync to Azure Files
   - Validated bi-directional sync

2. **Tiering Testing**
   - Monitored volume free space
   - Verified offline file attributes
   - Tested file recall

3. **Backup Testing**
   - Triggered on-demand backup
   - Verified backup job success
   - Tested file restore

4. **Network Testing**
   - Verified firewall rules
   - Tested access from allowed networks
   - Confirmed blocked access from internet

## 💰 Cost Estimate

**Monthly Azure Costs (Production):**
- Azure Files Premium (100 GiB): ~$13.60
- Storage Sync Service: Free
- Backup (100 GiB): ~$10.00
- Data transfer (minimal): ~$2.00
- **Total**: ~$25.60/month

**vs. On-Premises:**
- Hardware: $5,000 amortized = ~$140/month
- Power/cooling: ~$50/month
- Maintenance: ~$100/month
- **Total**: ~$290/month

**Savings**: ~$264/month (91% reduction)

## 📈 Performance Metrics

- **Sync Speed**: ~100 MB/min
- **Latency**: < 20ms (within region)
- **Throughput**: Up to 100 MB/s (Premium)
- **IOPS**: Up to 4,000 (Premium)
- **Backup Duration**: ~5 min for 2GB

## 🎓 Skills Demonstrated

- Azure Storage architecture
- Hybrid cloud solutions
- Backup and disaster recovery
- Network security configuration
- PowerShell automation
- Cost optimization strategies
- Change management procedures
- Documentation best practices

## 🔄 Production Cutover

### Preparation
1. Final sync verification
2. User notification
3. Backup validation
4. Rollback plan documented

### Cutover Window (3 hours)
1. Stop user access
2. Final sync
3. Update drive mappings
4. Test pilot group
5. Full user rollout

### Rollback (if needed)
- Keep on-prem server online for 30 days
- Files remain locally until tiering kicks in
- Can revert drive mappings instantly

## 🔍 Monitoring & Alerts

**Configured Alerts:**
- Sync health degraded
- Backup failure
- High latency (>50ms)
- Storage capacity >80%

**Dashboard Metrics:**
- File share capacity used
- Transaction count
- Sync errors
- Backup success rate

## 📚 Lessons Learned

1. **Cloud Tiering**: Aggressive tiering policies require user education
2. **Network**: VPN bandwidth impacts sync speed significantly
3. **Backup**: Regular restore testing is critical
4. **Permissions**: NTFS ACLs require careful planning for cloud

## 🎯 Real-World Application

This project demonstrates skills needed for:
- **Hybrid Cloud Migrations** - Every company moving to cloud needs this
- **Storage Consolidation** - Reduce on-prem footprint
- **DR Strategy** - Cloud-based backup and recovery
- **Cost Optimization** - Tiering and lifecycle management

## 👔 Business Impact

- **Eliminated** single point of failure (on-prem server)
- **Reduced** costs by 91%
- **Improved** data protection (automated backups)
- **Enabled** remote work (cloud access)
- **Simplified** IT operations (no hardware maintenance)

## 🔗 Additional Resources

- [Azure Files Documentation](https://docs.microsoft.com/azure/storage/files/)
- [Azure File Sync Documentation](https://docs.microsoft.com/azure/storage/file-sync/)
- [Azure Backup for Files](https://docs.microsoft.com/azure/backup/azure-file-share-backup-overview)

## 👨‍💻 Author

Youssef CHENNOUFI

---

**Last Updated**: October 2025  
**Azure Services**: Files, File Sync, Backup, Storage  