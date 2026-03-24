//
//  IncidentListView.swift
//  NurseryConnect
//
//  Purpose: Filterable incident queue with navigation to detail and creation.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - IncidentListView

/// Tab listing incidents for review and follow-up.
struct IncidentListView: View {
    @EnvironmentObject private var incidentViewModel: IncidentViewModel

    var body: some View {
        let rows = incidentViewModel.filteredIncidents()
        List {
            Section {
                Picker("Filter", selection: $incidentViewModel.listFilter) {
                    ForEach(IncidentListFilter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
            }

            Section {
                NavigationLink {
                    NewIncidentReportView(resumeReport: nil)
                } label: {
                    Text("Report New Incident")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryTeal)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                }
                .listRowInsets(EdgeInsets(
                    top: 8,
                    leading: LayoutConstants.horizontalPadding,
                    bottom: 8,
                    trailing: LayoutConstants.horizontalPadding
                ))
                .listRowBackground(Color.clear)
            }

            if rows.isEmpty {
                Section {
                    EmptyStateView(
                        icon: "exclamationmark.triangle",
                        title: "No incidents match this filter",
                        message: "Create a report whenever safety or wellbeing concerns arise."
                    )
                    .listRowBackground(Color.clear)
                }
            } else {
                Section {
                    ForEach(rows, id: \.id) { report in
                        NavigationLink {
                            IncidentDetailView(reportId: report.id)
                        } label: {
                            IncidentCard(report: report)
                        }
                        .listRowInsets(EdgeInsets(
                            top: 8,
                            leading: LayoutConstants.horizontalPadding,
                            bottom: 8,
                            trailing: LayoutConstants.horizontalPadding
                        ))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.softBackground)
        .navigationTitle("Incident Reports")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            incidentViewModel.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        IncidentListView()
    }
    .environmentObject(IncidentViewModel())
    .modelContainer(for: [Child.self, DiaryEntry.self, IncidentReport.self, BodyMapMarker.self], inMemory: true)
}
