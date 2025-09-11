// Client Supabase pour RAS Plomberie
import { createClient } from '@supabase/supabase-js'

// Configuration Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://votre-projet.supabase.co'
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'votre_cle_anonyme_supabase'

// Création du client Supabase
export const supabase = createClient(supabaseUrl, supabaseKey)

// Classe pour gérer les opérations CRUD du site
export class SiteDataManager {
    constructor() {
        this.supabase = supabase
    }

    // ===== GESTION DES COULEURS =====
    async getColors() {
        const { data, error } = await this.supabase
            .from('site_colors')
            .select('*')
            .order('id')
        
        if (error) throw error
        return data
    }

    async updateColor(colorName, colorValue) {
        const { data, error } = await this.supabase
            .from('site_colors')
            .update({ color_value: colorValue })
            .eq('color_name', colorName)
            .select()
        
        if (error) throw error
        return data
    }

    // ===== GESTION DU CONTENU =====
    async getContent() {
        const { data, error } = await this.supabase
            .from('site_content')
            .select('*')
            .eq('is_active', true)
            .order('position_order')
        
        if (error) throw error
        return data
    }

    async updateContent(elementId, contentData) {
        const { data, error } = await this.supabase
            .from('site_content')
            .upsert({
                element_id: elementId,
                ...contentData,
                updated_at: new Date().toISOString()
            })
            .select()
        
        if (error) throw error
        return data
    }

    async deleteContent(elementId) {
        const { data, error } = await this.supabase
            .from('site_content')
            .update({ is_active: false })
            .eq('element_id', elementId)
            .select()
        
        if (error) throw error
        return data
    }

    // ===== GESTION DES IMAGES =====
    async getImages() {
        const { data, error } = await this.supabase
            .from('site_images')
            .select('*')
            .eq('is_active', true)
            .order('position_order')
        
        if (error) throw error
        return data
    }

    async updateImage(imageName, imageData) {
        const { data, error } = await this.supabase
            .from('site_images')
            .upsert({
                image_name: imageName,
                ...imageData,
                updated_at: new Date().toISOString()
            })
            .select()
        
        if (error) throw error
        return data
    }

    // ===== GESTION DES INFORMATIONS DE CONTACT =====
    async getContactInfo() {
        const { data, error } = await this.supabase
            .from('contact_info')
            .select('*')
            .order('created_at', { ascending: false })
            .limit(1)
        
        if (error) throw error
        return data[0]
    }

    async updateContactInfo(contactData) {
        const { data, error } = await this.supabase
            .from('contact_info')
            .upsert(contactData)
            .select()
        
        if (error) throw error
        return data
    }

    // ===== GESTION DES SERVICES =====
    async getServices() {
        const { data, error } = await this.supabase
            .from('services')
            .select('*')
            .eq('is_active', true)
            .order('position_order')
        
        if (error) throw error
        return data
    }

    async updateService(serviceId, serviceData) {
        const { data, error } = await this.supabase
            .from('services')
            .update(serviceData)
            .eq('id', serviceId)
            .select()
        
        if (error) throw error
        return data
    }

    // ===== GESTION DES TÉMOIGNAGES =====
    async getTestimonials() {
        const { data, error } = await this.supabase
            .from('testimonials')
            .select('*')
            .eq('is_approved', true)
            .order('position_order')
        
        if (error) throw error
        return data
    }

    async addTestimonial(testimonialData) {
        const { data, error } = await this.supabase
            .from('testimonials')
            .insert(testimonialData)
            .select()
        
        if (error) throw error
        return data
    }

    // ===== GESTION DES DEMANDES DE CONTACT =====
    async saveContactRequest(requestData) {
        const { data, error } = await this.supabase
            .from('contact_requests')
            .insert(requestData)
            .select()
        
        if (error) throw error
        return data
    }

    async getContactRequests() {
        const { data, error } = await this.supabase
            .from('contact_requests')
            .select('*')
            .order('created_at', { ascending: false })
        
        if (error) throw error
        return data
    }

    async updateContactRequestStatus(requestId, status) {
        const { data, error } = await this.supabase
            .from('contact_requests')
            .update({ status })
            .eq('id', requestId)
            .select()
        
        if (error) throw error
        return data
    }

    // ===== SYNCHRONISATION =====
    async syncAllData() {
        try {
            const [colors, content, images, contactInfo, services, testimonials] = await Promise.all([
                this.getColors(),
                this.getContent(),
                this.getImages(),
                this.getContactInfo(),
                this.getServices(),
                this.getTestimonials()
            ])

            return {
                colors,
                content,
                images,
                contactInfo,
                services,
                testimonials
            }
        } catch (error) {
            console.error('Erreur lors de la synchronisation:', error)
            throw error
        }
    }

    // ===== ÉCOUTE DES CHANGEMENTS EN TEMPS RÉEL =====
    subscribeToChanges(callback) {
        const subscription = this.supabase
            .channel('site_changes')
            .on('postgres_changes', 
                { event: '*', schema: 'public', table: 'site_content' }, 
                callback
            )
            .on('postgres_changes', 
                { event: '*', schema: 'public', table: 'site_colors' }, 
                callback
            )
            .on('postgres_changes', 
                { event: '*', schema: 'public', table: 'contact_info' }, 
                callback
            )
            .subscribe()

        return subscription
    }
}

// Instance globale
export const siteDataManager = new SiteDataManager()

// Fonctions utilitaires
export const saveToSupabase = async (table, data) => {
    const { data: result, error } = await supabase
        .from(table)
        .upsert(data)
        .select()
    
    if (error) throw error
    return result
}

export const getFromSupabase = async (table, filters = {}) => {
    let query = supabase.from(table).select('*')
    
    Object.entries(filters).forEach(([key, value]) => {
        query = query.eq(key, value)
    })
    
    const { data, error } = await query
    
    if (error) throw error
    return data
}
