const API_BASE_URL = "http://localhost:8082/api";

// ============================================
// Types alignés avec les entités backend
// ============================================

export interface PatientDto {
  id: number;
  name: string;
  email: string;
  phone: string;
  // Le mot de passe est envoyé à la création mais n'est jamais renvoyé par l'API
  password?: string;
  age: number;
  gender: string; // 'M' ou 'F'
  condition?: string;
  status: 'critical' | 'high' | 'stable';
  lastVisit?: string; // Format: "YYYY-MM-DD"
  assignedDoctor?: string;
  adresse?: string;
}

export interface MedecinDto {
  id: number;
  nom: string;
  specialite: string;
  email: string;
  phone: string;
   // Le mot de passe est envoyé à la création mais n'est jamais renvoyé par l'API
  password?: string;
}

export interface AlerteDto {
  id: number;
  type: string;
  message: string;
  timestamp: string;
  patientId?: number;
  patientName?: string;
  medecinId?: number;
  patient?: {
    id: number;
    name: string;
    email?: string;
  };
}

// ============================================
// PATIENTS - CRUD complet
// ============================================

export async function getPatients(): Promise<PatientDto[]> {
  try {
    const res = await fetch(`${API_BASE_URL}/patients`);
    if (!res.ok) {
      const errorText = await res.text();
      throw new Error(`Erreur lors du chargement des patients: ${res.status} - ${errorText}`);
    }
    return res.json();
  } catch (error) {
    if (error instanceof TypeError && error.message.includes('Failed to fetch')) {
      throw new Error(`Erreur de connexion: Impossible de se connecter au serveur à ${API_BASE_URL}. Vérifiez que le backend est démarré.`);
    }
    throw error;
  }
}

export async function getPatientById(id: number): Promise<PatientDto> {
  const res = await fetch(`${API_BASE_URL}/patients/${id}`);
  if (!res.ok) {
    throw new Error("Erreur lors du chargement du patient");
  }
  return res.json();
}

export async function createPatient(patient: Omit<PatientDto, "id">): Promise<PatientDto> {
  const res = await fetch(`${API_BASE_URL}/patients`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(patient),
  });
  if (!res.ok) {
    const errorText = await res.text();
    let errorMessage = "Erreur lors de la création du patient";
    try {
      const errorJson = JSON.parse(errorText);
      errorMessage = errorJson.message || errorJson.error || errorMessage;
    } catch {
      errorMessage = errorText || errorMessage;
    }
    throw new Error(errorMessage);
  }
  return res.json();
}

export async function updatePatient(id: number, patient: Partial<PatientDto>): Promise<PatientDto> {
  const res = await fetch(`${API_BASE_URL}/patients/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(patient),
  });
  if (!res.ok) {
    const errorText = await res.text();
    let errorMessage = "Erreur lors de la mise à jour du patient";
    try {
      const errorJson = JSON.parse(errorText);
      errorMessage = errorJson.message || errorJson.error || errorMessage;
    } catch {
      errorMessage = errorText || errorMessage;
    }
    throw new Error(errorMessage);
  }
  return res.json();
}

export async function deletePatient(id: number): Promise<void> {
  const res = await fetch(`${API_BASE_URL}/patients/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) {
    throw new Error("Erreur lors de la suppression du patient");
  }
}

// ============================================
// MEDECINS - CRUD complet
// ============================================

export async function getMedecins(): Promise<MedecinDto[]> {
  const res = await fetch(`${API_BASE_URL}/medecins`);
  if (!res.ok) {
    throw new Error("Erreur lors du chargement des médecins");
  }
  return res.json();
}

export async function getMedecinById(id: number): Promise<MedecinDto> {
  const res = await fetch(`${API_BASE_URL}/medecins/${id}`);
  if (!res.ok) {
    throw new Error("Erreur lors du chargement du médecin");
  }
  return res.json();
}

export async function createMedecin(medecin: Omit<MedecinDto, "id">): Promise<MedecinDto> {
  const res = await fetch(`${API_BASE_URL}/medecins`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(medecin),
  });
  if (!res.ok) {
    const errorText = await res.text();
    let errorMessage = "Erreur lors de la création du médecin";
    try {
      const errorJson = JSON.parse(errorText);
      errorMessage = errorJson.message || errorJson.error || errorMessage;
    } catch {
      errorMessage = errorText || errorMessage;
    }
    throw new Error(errorMessage);
  }
  return res.json();
}

export async function updateMedecin(id: number, medecin: Partial<MedecinDto>): Promise<MedecinDto> {
  const res = await fetch(`${API_BASE_URL}/medecins/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(medecin),
  });
  if (!res.ok) {
    const errorText = await res.text();
    let errorMessage = "Erreur lors de la mise à jour du médecin";
    try {
      const errorJson = JSON.parse(errorText);
      errorMessage = errorJson.message || errorJson.error || errorMessage;
    } catch {
      errorMessage = errorText || errorMessage;
    }
    throw new Error(errorMessage);
  }
  return res.json();
}

export async function deleteMedecin(id: number): Promise<void> {
  const res = await fetch(`${API_BASE_URL}/medecins/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) {
    throw new Error("Erreur lors de la suppression du médecin");
  }
}

// ============================================
// ALERTES - CRUD complet
// ============================================

export async function getAlertes(): Promise<AlerteDto[]> {
  const res = await fetch(`${API_BASE_URL}/alertes`);
  if (!res.ok) {
    throw new Error("Erreur lors du chargement des alertes");
  }
  const alertes = await res.json();
  
  // Le backend retourne maintenant patientName directement dans le DTO
  return alertes.map((alerte: any) => {
    // Utiliser patientName du DTO si disponible, sinon essayer patient.name
    const patientName = alerte.patientName || 
                       alerte.patient?.name || 
                       (alerte.patientId ? `Patient ${alerte.patientId}` : 'Patient inconnu');
    
    return {
      ...alerte,
      patient: alerte.patient || (alerte.patientId ? {
        id: alerte.patientId,
        name: patientName
      } : undefined),
      patientId: alerte.patientId,
      patientName: patientName
    };
  });
}

export async function getAlerteById(id: number): Promise<AlerteDto> {
  const res = await fetch(`${API_BASE_URL}/alertes/${id}`);
  if (!res.ok) {
    throw new Error("Erreur lors du chargement de l'alerte");
  }
  return res.json();
}

export async function createAlerte(alerte: Omit<AlerteDto, "id">): Promise<AlerteDto> {
  const res = await fetch(`${API_BASE_URL}/alertes`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(alerte),
  });
  if (!res.ok) {
    throw new Error("Erreur lors de la création de l'alerte");
  }
  return res.json();
}

export async function deleteAlerte(id: number): Promise<void> {
  const res = await fetch(`${API_BASE_URL}/alertes/${id}`, {
    method: "DELETE",
  });
  if (!res.ok) {
    throw new Error("Erreur lors de la suppression de l'alerte");
  }
}
